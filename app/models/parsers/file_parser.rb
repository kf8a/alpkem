#Helper class to parse files for Run data
class FileParser
  attr_accessor :load_errors, :plot_errors, :measurements, :plot, :sample, :sample_type_id, :sample_date

  def self.for(sample_type_id,date)
    case sample_type_id
    when 1; LysimeterParser.new(    date, sample_type_id)
    when 2; StandardParser.new(     date, sample_type_id)
    when 3; OldSoilParser.new(      date, sample_type_id)
    when 4; GLBRCDeepParser.new(    date, sample_type_id)
    when 5; StandardParser.new(     date, sample_type_id)
    when 6; CNSampleParser.new(     date, sample_type_id)
    when 7; CNDeepParser.new(       date, sample_type_id)
    when 8; StandardParser.new(     date, sample_type_id)
    when 9; CNGLBRCParser.new(      date, sample_type_id)
    when 10; LysimeterNO3Parser.new(date, sample_type_id)
    when 11; LysimeterNH4Parser.new(date, sample_type_id)
    else false
    end
  end

  def initialize(date, id)
    self.sample_date = date
    self.sample_type_id = id
    self.plot_errors = ""
    self.load_errors = ""
    self.measurements = []
    @no3_analyte = Analyte.find_by_name('NO3')
    @nh4_analyte = Analyte.find_by_name('NH4')
    @nitrogen_analyte = Analyte.find_by_name('N')
    @carbon_analyte = Analyte.find_by_name('C')
  end

  def require_sample_type_id
    self.load_errors += "No Sample Type selected." unless self.sample_type_id
  end

  def require_sample_date
    self.load_errors += "No Sample Date selected." unless self.sample_date
  end

  def require_data(data)
    self.load_errors += "Data file is empty."      if data.size == 0
  end

  def parse_file(file)
    if file && !file.class.eql?(String)
      file_contents = StringIO.new(file.read)
      require_data(file_contents)
      require_sample_type_id
      require_sample_date
      if self.load_errors.blank?
        self.parse_data(file_contents)
      end
    else
      self.load_errors = 'No file was selected to upload.'
    end
  end

  def parse_data(data)
    data.each do | line |
      process_line(line)
    end
    if self.measurements.blank?
      self.load_errors += "No data was able to be loaded from this file."
    end
  end

  def cn_plot_name_ok?
    !@plot_name.blank? &&
        !@plot_name.include?("Standard") &&
        !@plot_name.include?("Blindstd")
  end

  def find_plot(plot_to_find)
    unless self.plot.try(:name) == plot_to_find
      self.plot = Plot.find_by_name(plot_to_find)
      self.plot_errors += "There is no plot named #{plot_to_find}" unless plot_exists?
    end
  end

  def plot_exists?
    !self.plot.blank?
  end

  def process_cn_sample
    if plot_exists?
      format_sample_date
      find_or_create_sample
      create_measurement(@percent_n, @nitrogen_analyte) if @percent_n
      create_measurement(@percent_c, @carbon_analyte) if @percent_c
    end
  end

  def format_sample_date
    unless self.sample_date.nil? || self.sample_date.class == Date
      self.sample_date = Date.strptime(self.sample_date, "%m/%d/%Y")
    end
  end

  def find_or_create_sample
    find_sample
    create_sample if self.sample.nil?
  end

  def find_sample
    right_plot = self.sample.try(:plot) == self.plot
    right_date = self.sample.try(:sample_date) == self.sample_date
    unless right_plot && right_date
      self.sample = Sample.find_by_plot_id_and_sample_date(self.plot.id, self.sample_date)
      if self.sample
        self.sample.approved = false    #unapprove sample when adding data
        self.sample.save
      end
    end
  end

  def create_sample
    self.sample                = Sample.new
    self.sample.sample_date    = self.sample_date
    self.sample.plot           = self.plot
    self.sample.sample_type_id = self.sample_type_id
    self.sample.save
  end

  def process_nhno_sample(nh4_amount, no3_amount)
    if plot_exists?
      find_or_create_sample
      create_measurement(nh4_amount, @nh4_analyte) if nh4_amount
      create_measurement(no3_amount, @no3_analyte) if no3_amount
    end
  end

  def create_measurement(amount, analyte)
    measurement = Measurement.new(:analyte => analyte, :amount => amount)
    self.sample.measurements  << measurement
    self.measurements         << measurement
  end
end
