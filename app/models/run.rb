class Run < ActiveRecord::Base
  has_many :measurements, :dependent => :destroy

  validates_presence_of :sample_type_id
  validates_presence_of :measurements, :message => "No measurements are associated with this run."

  def display_load_errors()
    return @load_errors
  end
  
  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.find(:all, :conditions => [%q{analyte_id = ?}, analyte.id])
  end

  def samples
    Sample.find(:all, :conditions => ['id in (select sample_id from measurements where run_id = ?)', self.id])
  end

  def updated?
    samples.collect {|x| x.updated_at > x.created_at}.uniq.include?(true)
  end

  #Things that need to be changed when adding new file type begins here
  
  LYSIMETER =           '\t(.{1,2})-(.)([A-C|a-c])( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  SOIL_SAMPLE =         '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_SOIL_SAMPLE =   '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_DEEP_CORE =     '\t\d{3}\tG(\d+)R(\d)S(\d)(\d{2})\w*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
  GLBRC_RESIN_STRIPS =  '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\t\s*-*\d\.\d+\t'

  def sample_type_name(id=sample_type_id)
    if id == 1
      return "Lysimeter"
    elsif id == 2
      return "Soil Sample"
    elsif id == 3
      return "GLBRC Soil Sample"
    elsif id == 4
      return "GLBRC Deep Core"
    elsif id == 5
      return "GLBRC Resin Strips"
    else
      return "Unknown Sample Type"
    end
  end
  
  def get_regex_by_sample_type_id(id=sample_type_id)
    if id == 1
      return Regexp.new(LYSIMETER)
    elsif id == 2
      return Regexp.new(SOIL_SAMPLE)
    elsif id == 3
      return Regexp.new(GLBRC_SOIL_SAMPLE)
    elsif id == 4
      return Regexp.new(GLBRC_DEEP_CORE)
    elsif id == 5
      return Regexp.new(GLBRC_RESIN_STRIPS)
    else
      return Regexp.new("")
    end
  end
  
  def load(data)
    @load_errors = ""
    if data.size == 0
      @load_errors = "Data file is empty."
      return false
    end
    unless sample_type_id
      @load_errors = "No Sample Type selected."
      return false
    end
    unless sample_date
      @load_errors = "No Sample Date selected."
      return false
    end
    
    analyte_no3 = Analyte.find_by_name('NO3')
    analyte_nh4 = Analyte.find_by_name('NH4')
    re = get_regex_by_sample_type_id
    
    data.each do | line |
      next unless line =~ re
      # find plot
#      plot = Plot.find_by_treatment_and_replicate('T'+$1, 'R'+$2)

      # HACK Warning samples for soil N also should have a sample data.

      plot =  nil
      s_date = nil
      case sample_type_id
      when 1 #lysimeter
        plot = Plot.find_by_name("T#{$1}R#{$2}F#{$3}")
        s_date = $4
      when 2 # LTER Soil sample
        plot = Plot.find_by_name("T#{$1}R#{$2}")
        s_date = sample_date
      when 3 # GLBRC Soil
        plot = Plot.find_by_name("G#{$1}R#{$2}")
        s_date = sample_date
      when 4 # GLBRC Deep
        plot = Plot.find_by_name("G#{$1}R#{$2}S#{$3}#{$4}")
        s_date = sample_date
      when 5 # GLBRC Resin Strips
        plot = Plot.find_by_name("G#{$1}R#{$2}")
        s_date = sample_date
      when 6 
        plot = Plot.find_by_name("T#{$1}R#{$2}F#{$3}")
        s_date = sample_date
      else
        raise "not implemented"
      end       

  #Things that need to be changed when adding new file type ends here
      
      #TODO better reporting if we can't parse
      unless plot
        @load_errors = "File not parsable."
        next
      end
      
      # find sample
      sample = Sample.find_by_plot_id_and_sample_date(plot.id, s_date)

      if sample.nil? then
        sample = Sample.new

        sample.sample_date = s_date

        sample.plot = plot
        sample.sample_type_id = sample_type_id
        sample.save
      end

      # create a new measurement
      no3 = Measurement.new

      no3.analyte = analyte_no3
      if sample_type_id == 1 || sample_type_id == 4
        no3.amount = $6
      elsif sample_type_id == 2 || sample_type_id == 3 || sample_type_id == 5
        no3.amount = $5
      else
        raise "not implemented"
      end
      no3.save
      sample.measurements << no3
      self.measurements << no3

      nh4 = Measurement.new
      nh4.analyte = analyte_nh4

      if sample_type_id == 1 || sample_type_id == 4
        nh4.amount = $5
      elsif sample_type_id == 2 || sample_type_id == 3 || sample_type_id == 5
        nh4.amount = $4
      else
        raise "not implemented"
      end
      nh4.save

      sample.measurements << nh4
      self.measurements << nh4
    end
  end
end
