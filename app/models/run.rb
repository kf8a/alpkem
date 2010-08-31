class Run < ActiveRecord::Base
  has_many :measurements, :dependent => :destroy
  has_many :cn_measurements, :dependent => :destroy

  validates_presence_of :sample_type_id
  validates_presence_of :measurements, :message => "No measurements are associated with this run.", :unless => :cn_measurements_exist

  def cn_measurements_exist
    !cn_measurements.blank?
  end
  
  def display_load_errors()
    @load_errors
  end
  
  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.find_all_by_analyte_id(analyte.id)
  end
  
  def analytes
    list_of_analytes = []
    if cn_measurements_exist
      list_of_analytes << Analyte.find_by_name('N')
      list_of_analytes << Analyte.find_by_name('C')
    else
      list_of_analytes << Analyte.find_by_name('NO3')
      list_of_analytes << Analyte.find_by_name('NH4')
    end
  end
  
  def samples
    if cn_measurements_exist
      CnSample.find(:all, :conditions => ['id in (select cn_sample_id from cn_measurements where run_id = ?)', self.id])
    else
      Sample.find(:all, :conditions => ['id in (select sample_id from measurements where run_id = ?)', self.id])
    end
  end
    
  def updated?
    samples.collect {|x| x.updated_at > x.created_at}.uniq.include?(true)
  end

#--Things that need to be changed when adding new file type begins here--

  LYSIMETER           = '\t(.{1,2})-(.)([A-C|a-c])( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  SOIL_SAMPLE         = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_SOIL_SAMPLE   = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_DEEP_CORE     = '\t\d{3}\tG(\d+)R(\d)S(\d)(\d{2})\w*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_RESIN_STRIPS  = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)\t'
  CN_SAMPLE           = ',(\d*),(\d\d\/\d\d\/\d\d\d\d)?,"\d*(.{1,11})[ABC]?","?(\w*)"?,"(.*)",(\d*\.\d*),.*,"?(\w*)"?,(\d*\.\d*),(\d*\.\d*)'
  CN_DEEP_CORE        = ',\d*,\d*(.{1,11})[ABC]?,(\d*\.\d*),\w*,(\w*),\w*,\w*,\w*,(\d*\.\d*),(\d*\.\d*)'
  GLBRC_SOIL_SAMPLE_NEW = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)\t'
  LTER_SOIL_SAMPLE_NEW = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)\t'
  
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
    else    "Unknown Sample Type"
    end
  end
  
  def get_regex_by_sample_type_id(id=sample_type_id)
    case id
    when 1; Regexp.new(LYSIMETER)
    when 2; Regexp.new(LTER_SOIL_SAMPLE_NEW)
    when 3; Regexp.new(GLBRC_SOIL_SAMPLE)
    when 4; Regexp.new(GLBRC_DEEP_CORE)
    when 5; Regexp.new(GLBRC_RESIN_STRIPS)
    when 6; Regexp.new(CN_SAMPLE)
    when 7; Regexp.new(CN_DEEP_CORE)
    when 8; Regexp.new(GLBRC_SOIL_SAMPLE_NEW)
    else    Regexp.new("")
    end
  end
  
  def load(data)
    @load_errors = ""
    
    @load_errors = "Data file is empty."      if data.size == 0 
    @load_errors = "No Sample Type selected." unless sample_type_id
    @load_errors = "No Sample Date selected." unless sample_date
    
    if @load_errors.blank?
      re = get_regex_by_sample_type_id
      @plot = nil
      @sample = nil
    
      data.each do | line |
        next unless line =~ re

        # HACK Warning samples for soil N also should have a sample data.
        case sample_type_id
        when 1 #lysimeter
          s_date      = $4
          nh4_amount  = $5
          no3_amount  = $6
          @plot = find_plot("T#{$1}R#{2}F#{$3}")
          process_nhno_sample(s_date, nh4_amount, no3_amount)
        when 2 # LTER Soil sample
          s_date      = sample_date
          nh4_amount  = $4
          no3_amount  = $5
          @plot = find_plot("T#{$1}R#{$2}")
          process_nhno_sample(s_date, nh4_amount, no3_amount)
        when 3 # GLBRC Soil
          s_date      = sample_date
          nh4_amount  = $4
          no3_amount  = $5
          @plot = find_plot("G#{$1}R#{$2}")
          process_nhno_sample(s_date, nh4_amount, no3_amount)
        when 4 # GLBRC Deep
          s_date      = sample_date
          nh4_amount  = $5
          no3_amount  = $6
          @plot = find_plot("G#{$1}R#{$2}S#{$3}#{$4}")
          process_nhno_sample(s_date, nh4_amount, no3_amount)
        when 5 # GLBRC Resin Strips
          s_date      = sample_date
          nh4_amount  = $4
          no3_amount  = $5
          @plot = find_plot("G#{$1}R#{$2}")
          process_nhno_sample(s_date, nh4_amount, no3_amount)
        when 6
          s_date      = $2
          cn_plot     = $3
          cn_type     = $5
          weight      = $6
          percent_n   = $8
          percent_c   = $9
          process_cn_sample(s_date, cn_plot, cn_type, percent_n, percent_c)
        when 7  #CN GLBRC Deepcore
          s_date      = sample_date
          cn_plot     = $1
          weight      = $2
          cn_type     = $3
          percent_n   = $4
          percent_c   = $5
          process_cn_sample(s_date, cn_plot, cn_type, percent_n, percent_c)
        when 8 # GLBRC Soil new
          s_date      = sample_date
          nh4_amount  = $4
          no3_amount  = $5
          @plot = find_plot("G#{$1}R#{$2}")
          process_nhno_sample(s_date, nh4_amount, no3_amount)
        else
          raise "not implemented"
        end
      end
    end
  end
  
#--Things that need to be changed when adding new file type ends here--

  def find_plot(plot_to_find)
    if @plot.try(:name) == plot_to_find
      @plot
    else
      Plot.find_by_name(plot_to_find)
    end
  end

  def process_cn_sample(s_date, cn_plot, cn_type, percent_n, percent_c)
    return if percent_n.blank? or percent_c.blank? or cn_plot.blank?
    
    unless s_date.nil? or s_date.class == Date
      s_date = Date.strptime(s_date, "%m/%d/%Y")
    end
    
    # find sample unless already found
    unless @sample.try(:cn_plot) == cn_plot and @sample.try(:sample_date) == s_date
      @sample = CnSample.find_by_cn_plot_and_sample_date(cn_plot, s_date)
    end

    if @sample.nil? then
      @sample                = CnSample.new
      @sample.sample_date    = s_date
      @sample.cn_plot        = cn_plot
      @sample.save
    end

    # create a new measurement
    @analyte_percent_n  = (@analyte_percent_n or Analyte.find_by_name('N'))
    nitrogen            = CnMeasurement.new
    nitrogen.analyte    = @analyte_percent_n
    nitrogen.amount     = percent_n
    nitrogen.save
    
    @sample.cn_measurements << nitrogen
    self.cn_measurements   << nitrogen

    @analyte_percent_c = (@analyte_percent_c or Analyte.find_by_name('C'))    
    carbon             = CnMeasurement.new
    carbon.analyte     = @analyte_percent_c
    carbon.amount      = percent_c
    carbon.save    

    @sample.cn_measurements << carbon
    self.cn_measurements   << carbon
  end
  
  def process_nhno_sample(s_date, nh4_amount, no3_amount)
    return if no3_amount.blank? or nh4_amount.blank? or @plot.blank?
    
    # find sample unless already found
    unless @sample.try(:plot) == @plot and @sample.try(:sample_date) == s_date
      @sample = Sample.find_by_plot_id_and_sample_date(@plot.id, s_date)
    end

    if @sample.nil? then
      @sample                = Sample.new
      @sample.sample_date    = s_date
      @sample.plot           = @plot
      @sample.sample_type_id = sample_type_id
      @sample.save
    end


    # create a new measurement
    @analyte_no3  = (@analyte_no3 or Analyte.find_by_name('NO3'))
    no3           = Measurement.new
    no3.analyte   = @analyte_no3
    no3.amount    = no3_amount
    no3.save

    @sample.measurements << no3
    self.measurements   << no3

    @analyte_nh4  = (@analyte_nh4 or Analyte.find_by_name('NH4'))
    nh4           = Measurement.new
    nh4.analyte   = @analyte_nh4
    nh4.amount    = nh4_amount
    nh4.save

    @sample.measurements << nh4
    self.measurements   << nh4
  end
end
