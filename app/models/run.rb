class Run < ActiveRecord::Base
    has_many :measurements, :dependent => :destroy

    validates_presence_of :sample_type_id

    #SOIL_SAMPLE = Tab, then exactly 3 digits, then Tab, then optional:(1 or 2 word characters), then dash, then one optional digit, then a single letter a, b, c, A, B or C, then optionally "rerun", then
    SOIL_SAMPLE = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
    LYSIMETER = '\t(.{1,2})-(.)([A-C|a-c])( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
    GLBRC_SOIL_SAMPLE = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
    GLBRC_DEEP_CORE = '\t\d{3}\tG(\d+)R(\d)S(\d)(\d{2})\w*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'

    def measurements_by_analyte(analyte)
      raise ArgumentError unless analyte.class == Analyte
      measurements.find(:all, :conditions => [%q{analyte_id = ?}, analyte.id])
    end

    def samples
      Sample.find(:all, :conditions => ['id in (select sample_id from measurements where run_id = ?)', self.id])
    end
    
    def sample_type_name(id=sample_type_id)
      if id == 1
        return "Lysimeter"
      elsif id == 2
        return "Soil Sample"
      elsif id == 3
        return "GLBRC Soil Sample"
      elsif id == 4
        return "GLBRC Deep Core"
      else
        return "Unknown Sample Type"
      end
    end
    
    def updated?
      samples.collect {|x| x.updated_at > x.created_at}.uniq.include?(true)
    end


    def load(data, sample_type_id=2)
      return if data.size == 0
      analyte_no3 = Analyte.find_by_name('NO3')
      analyte_nh4 = Analyte.find_by_name('NH4')

      if sample_type_id == 1
        re = Regexp.new(LYSIMETER)
      elsif sample_type_id == 2
        re = Regexp.new(SOIL_SAMPLE)
      elsif sample_type_id == 3
        re = Regexp.new(GLBRC_SOIL_SAMPLE)
      elsif sample_type_id == 4
        re = Regexp.new(GLBRC_DEEP_CORE)
      else
        re = Regexp.new("")
      end
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
        
        #TODO better reporting if we can't parse
        raise 'not parsable' unless plot
        
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
