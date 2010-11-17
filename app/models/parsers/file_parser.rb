#Helper class to parse files for Run data
class FileParser
  
  attr_reader :load_errors, :plot_errors, :measurements, :sample_type_id, :plot, :sample
  
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
    @sample_date = date
    @sample_type_id = id
    @plot_errors = ""
    @load_errors = ""
    @measurements = []
  end

  def require_sample_type_id
    @load_errors += "No Sample Type selected." unless @sample_type_id
  end

  def require_sample_date
    @load_errors += "No Sample Date selected." unless @sample_date
  end

  def require_data(data)
    @load_errors += "Data file is empty."      if data.size == 0
  end

  def parse_file(file)
    if file && !file.class.eql?(String)
      file_contents = StringIO.new(file.read)
      require_data(file_contents)
      require_sample_type_id
      require_sample_date
      if @load_errors.blank?
        self.parse_data(file_contents)
      end
    else
      @load_errors = 'No file was selected to upload.'
    end
  end

  def parse_data(data)
    data.each do | line |
      process_line(line)
    end
    if self.measurements.blank?
      @load_errors += "No data was able to be loaded from this file."
    end
  end
  
  def cn_plot_name_ok?(plot_name)
    !plot_name.blank? &&
        !plot_name.include?("Standard") &&
        !plot_name.include?("Blindstd")
  end

  def find_plot(plot_to_find)
    if @plot.try(:name) == plot_to_find
      @plot
    else
      @plot = Plot.find_by_name(plot_to_find)
      @plot_errors += "There is no plot named #{plot_to_find}" if @plot.blank?
    end
    @plot
  end

  def process_cn_sample(s_date, percent_n, percent_c)
    return if percent_n.blank? || percent_c.blank? || @plot.blank?

    unless s_date.nil? || s_date.class == Date
      s_date = Date.strptime(s_date, "%m/%d/%Y")
    end

    find_or_create_sample(s_date)

    @analyte_N ||= Analyte.find_by_name('N')
    @analyte_C ||= Analyte.find_by_name('C')

    create_measurement(percent_n, @analyte_N)
    create_measurement(percent_c, @analyte_C)
  end

  def find_or_create_sample(date)
    @sample = find_sample(date)

    if @sample.nil? then
      create_sample(date)
    else
      @sample
    end
  end

  def find_sample(date)
     right_plot = @sample.try(:plot) == @plot
     right_date = @sample.try(:sample_date) == date
     unless right_plot && right_date
       @sample = Sample.find_by_plot_id_and_sample_type_id_and_sample_date(@plot.id, @sample_type_id, date)
       if @sample
         @sample.approved = false    #unapprove sample when adding data
         @sample.save
       end
       @sample
     else
       @sample
     end
  end

  def create_sample(date)
    @sample                = Sample.new
    @sample.sample_date    = date
    @sample.plot           = @plot
    @sample.sample_type_id = @sample_type_id
    @sample.save
    @sample
  end

  def process_nhno_sample(s_date, nh4_amount, no3_amount)
    return if @plot.blank?

    sample = find_or_create_sample(s_date)

    @analyte_no3  = (@analyte_no3 || Analyte.find_by_name('NO3'))
    @analyte_nh4  = (@analyte_nh4 || Analyte.find_by_name('NH4'))

    create_measurement(no3_amount, @analyte_no3) if no3_amount
    create_measurement(nh4_amount, @analyte_nh4) if nh4_amount
  end

  def create_measurement(amount, analyte)
    measurement = Measurement.new(:analyte => analyte, :amount => amount)
    @sample.measurements << measurement
    @measurements        << measurement
  end
end
