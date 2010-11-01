class Run < ActiveRecord::Base
  has_many :measurements, :dependent => :destroy
  has_many :cn_measurements, :dependent => :destroy

  validates :sample_type_id, :presence => true
  validates :measurements, :presence => { :unless => :cn_measurements_exist? }

  def self.runs
    all_runs = Run.order('sample_date')
    runs_index = []
    all_runs.each do |run|
      runs_index << run unless run.cn_measurements_exist?
    end
    runs_index
  end

  def self.cn_runs
    all_runs = Run.order('sample_date')
    runs_index = []
    all_runs.each do |run|
      runs_index << run if run.cn_measurements_exist?
    end
    runs_index
  end

  def cn_measurements_exist?
    !cn_measurements.blank?
  end
  
  def load_errors
    @load_errors ||= ""
  end

  def plot_errors
    @plot_errors ||= ""
  end
  
  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.find_all_by_analyte_id(analyte.id)
  end
  
  def analytes
    list_of_analytes = []
    if cn_measurements_exist?
      list_of_analytes << Analyte.find_by_name('N')
      list_of_analytes << Analyte.find_by_name('C')
    else
      list_of_analytes << Analyte.find_by_name('NH4')
      list_of_analytes << Analyte.find_by_name('NO3')
    end
  end
  
  def samples
    if cn_measurements_exist?
      CnSample.where('id in (select cn_sample_id from cn_measurements where run_id = ?)', self.id)
    else
      Sample.where('id in (select sample_id from measurements where run_id = ?)', self.id)
    end
  end
    
  def updated?
    samples.collect {|x| x.updated_at > x.created_at}.uniq.include?(true)
  end

#--Things that need to be changed when adding a new file type begin here--

  LYSIMETER_OLD       = '\t(.{1,2})-(.)([A-C|a-c])( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  LYSIMETER           = '(\w{1,2})-(\d)-(\d)([ABC|abc]), (\d{8}).+\d+\t\s+(-?\d+\.\d+)\t+\s+\d+\t\s+(-?\d+\.\d+)'
  STANDARD_SAMPLE     = '\t\d{3}\t(L?\w{1,2})-?S?(\d{1,2})[abc|ABC]( rerun)*\t\s+-*(\d+).+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)'
  OLD_SOIL_SAMPLE     = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*(\d+)\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_DEEP_CORE     = '\t\d{3}\tG(\d+)R(\d)S(\d)(\d{2})\w*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_CN            = '(\d+),\d+,\d+([G|L|M]\d+[R|S]\d{2}0\d{2})[ABC|abc],(\d+\.\d+),\d+,.+,(\d+\.\d+),(\d+\.\d+)'
  CN_SAMPLE           = ',(\d*),(\d\d\/\d\d\/\d\d\d\d)?,"\d*(.{1,11})[ABC]?","?(\w*)"?,"(.*)",(\d*\.\d*),.*,"?(\w*)"?,(\d*\.\d*),(\d*\.\d*)'
  CN_DEEP_CORE        = ',\d*,\d*(.{1,11})[abc|ABC]?,(\d*\.\d*),\w*,(\w*),\w*,\w*,\w*,(\d*\.\d*),(\d*\.\d*)'
#  CN_DEEP_CORE        = ',\d*,(\d+)(.+)[ABC],(\d+.\d+),\d+,.*,,(\d+.\d+),(\d+.\d+)'

  
  def sample_type_name(id=sample_type_id)
    case id
    when 1; "Lysimeter"
    when 2; "Soil Sample"
    when 3; "GLBRC Soil Sample"
    when 4; "GLBRC Deep Core Nitrogen"
    when 5; "GLBRC Resin Strips"
    when 6; "CN Soil Sample"
    when 7; "CN Deep Core"
    when 8; "GLBRC Soil Sample (New)"
    when 9; "GLBRC CN"
    else    "Unknown Sample Type"
    end
  end
  
  def get_regex_by_format_type(format_type)
    case format_type
    when "Lysimeter";     Regexp.new(LYSIMETER)
    when "Standard";      Regexp.new(STANDARD_SAMPLE)
    when "Old Soil";      Regexp.new(OLD_SOIL_SAMPLE)
    when "GLBRC Deep";    Regexp.new(GLBRC_DEEP_CORE)
    when "CN Sample";     Regexp.new(CN_SAMPLE)
    when "CN Deep";       Regexp.new(CN_DEEP_CORE)
    when "CN GLBRC";      Regexp.new(GLBRC_CN)
    else                  Regexp.new("")
    end
  end

  def file_format_by_sample_type_id(id=sample_type_id)
    case id
    when 1; "Lysimeter"
    when 2; "Standard"
    when 3; "Old Soil"
    when 4; "GLBRC Deep"
    when 5; "Standard"
    when 6; "CN Sample"
    when 7; "CN Deep"
    when 8; "Standard"
    when 9; "CN GLBRC"
    else    "Unknown format"
    end
  end
  
  def load_file(file)
    if file && !file.class.eql?(String)
      file_contents = StringIO.new(file.read)
      self.load(file_contents)
      if self.measurements.blank? && self.cn_measurements.blank?
        @load_errors += "No data was able to be loaded from this file."
      end
    else
      @load_errors = 'No file was selected to upload.'
    end
  end

  def load(data)
    @load_errors = ""
    @plot_errors = ""
    
    @load_errors += "Data file is empty."      if data.size == 0
    @load_errors += "No Sample Type selected." unless sample_type_id
    @load_errors += "No Sample Date selected." unless sample_date
    
    if @load_errors.blank?
      format_type = file_format_by_sample_type_id(sample_type_id)
      re = get_regex_by_format_type(format_type)
      @plot = nil
      @sample = nil

#      parser = FileParser.create(sample_type_and_format)

      data.each do | line |
      #   date,plot, sample = parser.parse(line)
      # end
        unless line =~ re
          p line
        end
        next unless line =~ re

        if format_type == "Lysimeter"
           s_date = $5
        elsif format_type ==  "CN Sample"
          s_date = $2
        elsif format_type == 'CN GLBRC'
          s_date = Date.parse($1)
        else
          s_date = sample_date
        end
        
  
        if ["GLBRC Deep","Standard","Old Soil"].include?(format_type)
          nh4_amount = $5
          no3_amount = $6
        end

        case format_type
        when 'CN Sample'
          percent_n   = $8
          percent_c   = $9
        when 'CN Deep'
          percent_n   = $4
          percent_c   = $5
        when 'Lysimeter'
          nh4_amount  = $6
          no3_amount  = $7
        when 'CN GLBRC'
          percent_n   = $4
          percent_c   = $5
        end

        first = $1
        second = $2
        third = $3
        fourth = $4

        case format_type
        when "Lysimeter"
          plot_name = "T#{first}R#{second}F#{third}"
          @plot = find_plot(plot_name)
          unless first.blank? || second.blank? || third.blank?
            @plot_errors += "There is no plot named #{plot_name}" if @plot.blank?
          end
        when "Standard"
          if sample_type_id == 2
            plot_name = "T#{first}R#{second}"
            @plot = find_plot(plot_name)
            unless first.blank? || second.blank?
              @plot_errors += "There is no plot named #{plot_name}" if @plot.blank?
            end
          elsif first.start_with?("L0")
            first.slice!("L0")
            plot_name = "L0#{first.to_i}S#{second}"
            @plot = find_plot(plot_name)
            unless second.blank?
              @plot_errors += "There is no plot named #{plot_name}" if @plot.blank?
            end
          else
            plot_name = "G#{first}R#{second}"
            @plot = find_plot(plot_name)
            unless first.blank? || second.blank?
              @plot_errors += "There is no plot named #{plot_name}" if @plot.blank?
            end
          end
        when "Old Soil"
          
          plot_name = "G#{first}R#{second}"
          @plot = find_plot(plot_name)
          unless first.blank? || second.blank?
            @plot_errors += "There is no plot named #{plot_name}" if @plot.blank?
          end
        when "GLBRC Deep"
          plot_name = "G#{first}R#{second}S#{third}#{fourth}"
          @plot = find_plot(plot_name)
          unless first.blank? || second.blank? || third.blank? || fourth.blank?
            @plot_errors += "There is no plot named #{plot_name}" if @plot.blank?
          end
        when "CN Sample"
          cn_plot     = third
        when "CN Deep"
          cn_plot     = first
        when "CN GLBRC"
          cn_plot     = second
        else
          raise "not implemented"
        end

#--Things that need to be changed when adding new file type ends here--

        if nh4_amount || no3_amount
          process_nhno_sample(s_date, nh4_amount, no3_amount)
        elsif percent_n || percent_c
          process_cn_sample(s_date, cn_plot, percent_n, percent_c)
        end
      end
    end
  end
  
  def find_plot(plot_to_find)
    if @plot.try(:name) == plot_to_find
      @plot
    else
      Plot.find_by_name(plot_to_find)
    end
  end

  def find_cnsample(plot, date)
    right_plot = @sample.try(:cn_plot) == plot
    right_date = @sample.try(:sample_date) == date
    unless right_plot && right_date
      @sample = CnSample.find_by_cn_plot_and_sample_date(plot, date)
      if @sample
        @sample.approved = false
        @sample.save
      end
    end
  end

  def process_cn_sample(s_date, cn_plot, percent_n, percent_c)
    return if percent_n.blank? || percent_c.blank? || cn_plot.blank?
    
    unless s_date.nil? || s_date.class == Date
      s_date = Date.strptime(s_date, "%m/%d/%Y")
    end
    
    find_cnsample(cn_plot, s_date)
    
    if @sample.nil? then
      @sample                = CnSample.new
      @sample.sample_date    = s_date
      @sample.cn_plot        = cn_plot
      @sample.save
    end

    create_cn_measurement(percent_n, 'N')
    create_cn_measurement(percent_c, 'C')
   end
  
  def create_cn_measurement(amount, analyte_name)
    analyte     = Analyte.find_by_name(analyte_name)    
    measurement = CnMeasurement.create(:amount => amount, :analyte => analyte)

    @sample.cn_measurements << measurement
    self.cn_measurements    << measurement
  end
 
  def find_sample(plot, date)
    right_plot = @sample.try(:plot) == plot
    right_date = @sample.try(:sample_date) == date
    unless right_plot && right_date
      @sample = Sample.find_by_plot_id_and_sample_date(plot.id, date)
      if @sample
        @sample.approved = false    #unapprove sample when adding data
        @sample.save
      end
      @sample
    end
  end

  def process_nhno_sample(s_date, nh4_amount, no3_amount)
    return if @plot.blank?
    
    find_sample(@plot, s_date)

    if @sample.nil? then
      @sample                = Sample.new
      @sample.sample_date    = s_date
      @sample.plot           = @plot
      @sample.sample_type_id = sample_type_id
      @sample.save
    end
    
    @analyte_no3  = (@analyte_no3 || Analyte.find_by_name('NO3'))
    @analyte_nh4  = (@analyte_nh4 || Analyte.find_by_name('NH4'))
    
    create_measurement(no3_amount, @analyte_no3) if no3_amount
    create_measurement(nh4_amount, @analyte_nh4) if nh4_amount
  end
  
  def create_measurement(amount, analyte)
    measurement = Measurement.new(:analyte => analyte, :amount => amount)
    @sample.measurements << measurement
    self.measurements    << measurement
  end

end
