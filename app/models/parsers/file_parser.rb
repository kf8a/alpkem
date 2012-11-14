#Helper class to parse files for Run data
class Parsers::FileParser
  attr_accessor :load_errors, :plot_errors, :measurements, :plot, :sample, :sample_type_id, :sample_date

  # These subclasses are really line parsers.
  def self.for(sample_type_id,date)
    klass = case sample_type_id
        when 1; Parsers::LysimeterParser
        when 2; Parsers::StandardParser
        when 3; Parsers::OldSoilParser
        when 4; Parsers::GLBRCDeepParser
        when 5; Parsers::StandardParser
        when 6; Parsers::CNSampleParser
        when 7; Parsers::CNDeepParser
        when 8; Parsers::StandardParser
        when 9; Parsers::CNGLBRCParser
        # when 10; Parsers::LysimeterNO3Parser
        # when 11; Parsers::LysimeterNH4Parser
        when 12; Parsers::GLBRCCNPlantParser
        when 13; Parsers::LeileiSampleParser
        when 14; Parsers::LTERCNPlantParser
        when 15; Parsers::LterCnDeepParser
        when 16; Parsers::StandardParser
        else false
        end

    klass.new(date, sample_type_id) if klass
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

  # subclasses need to implement this
  def process_line(line)
    raise NotImplementedError
  end

  def parse_file(file)
    if file && !file.class.eql?(String)
      parse_contents(file)
    else
      self.load_errors = 'No file was selected to upload.'
    end
  end

  def parse_contents(file)
    file_contents = StringIO.new(file.read)
    require_data(file_contents)
    require_sample_type_id
    require_sample_date
    self.parse_data(file_contents) if self.load_errors.blank?
  end

  # subclasses should override this if they need to specifiy
  # different line parsers for the sample type
  def parse_data(data)
    data.each { | line | process_line(line) }
    if self.measurements.blank?
      self.load_errors += "No data was able to be loaded from this file."
    end
  end

  def find_plot(plot_to_find)
    self.plot = Plot.find_by_name(plot_to_find)
    self.plot_errors += "There is no plot named #{plot_to_find}" unless plot.present?
  end

  def find_or_create_sample
    find_sample unless sample_already_found?
    self.sample ? unapprove_sample : create_sample
  end

  def find_sample
    self.sample = self.plot.samples.find_by_sample_date(self.sample_date)
  end

  def create_sample
    self.sample = Sample.create(:sample_date => self.sample_date,
                                :plot => self.plot,
                                :sample_type_id => self.sample_type_id)
  end

  private##########################

  def require_sample_type_id
    self.load_errors += "No Sample Type selected." unless self.sample_type_id
  end

  def require_sample_date
    self.load_errors += "No Sample Date selected." unless self.sample_date
  end

  def require_data(data)
    self.load_errors += "Data file is empty."      if data.size == 0
  end

  def cn_plot_name_ok?
    !@plot_name.blank? &&
        !@plot_name.include?("Standard") &&
        !@plot_name.include?("Blindstd")
  end

  def process_cn_sample
    format_sample_date if self.sample_date.class == String
    find_or_create_sample
    create_measurement(@percent_n, @nitrogen_analyte) unless @percent_n.blank?
    create_measurement(@percent_c, @carbon_analyte) unless @percent_c.blank?
  end

  def format_sample_date
    self.sample_date = Date.strptime(self.sample_date, "%m/%d/%Y")
  end

  def unapprove_sample
    self.sample.unapprove #New data makes sample unapproved
  end

  def sample_already_found?
    self.sample && right_plot? && right_date?
  end

  def right_plot?
    self.sample.plot == self.plot
  end

  def right_date?
    self.sample.sample_date == self.sample_date
  end

  def process_nhno_sample(nh4_amount, no3_amount)
    find_or_create_sample
    create_measurement(nh4_amount, @nh4_analyte) unless nh4_amount.blank?
    create_measurement(no3_amount, @no3_analyte) unless no3_amount.blank?
  end

  def create_measurement(amount, analyte)
    measurement = Measurement.new(:analyte => analyte, :amount => amount)
    self.sample.measurements  << measurement
    self.measurements         << measurement
  end

end
