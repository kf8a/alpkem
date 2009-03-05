class Run < ActiveRecord::Base
    has_many :measurements, :dependent => :destroy
    belongs_to :sample_type

    validates_presence_of :sample_type
    
    acts_as_authentic
    
    SOIL_SAMPLE = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'
    LYSIMETER = '\t(.{1,2})-(.)([A-C|a-c])( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'

    def measurements_by_analyte(analyte)
      raise ArgumentError unless analyte.class == Analyte
      measurements.find(:all, :conditions => [%q{analyte_id = ?}, analyte.id])
    end

    def samples
      Sample.find(:all, :conditions => ['id in (select sample_id from measurements where run_id = ?)', self.id])
    end


    def load(file_data, sample_type_id=2)
      return if file_data.size == 0
      analyte_no3 = Analyte.find_by_name('NO3')
      analyte_nh4 = Analyte.find_by_name('NH4')
      data = file_data.read 
      sample_type = SampleType.find(sample_type_id)
      re = Regexp.new(sample_type.regular_expression)
      data.each do | line |
        next unless line =~ re
        
        # find plot
  #      plot = Plot.find_by_treatment_and_replicate('T'+$1, 'R'+$2)

        # HACK Warning samples for soil N also should have a sample data.

        plot =  nil
        s_date = nil
        if sample_type_id == 1
          plot = Plot.find_by_name("T#{$1}R#{$2}F#{$3}")
          s_date = $4
        else  
          plot = Plot.find_by_name("T#{$1}R#{$2}")
          s_date = sample_date
        end       
        # find sample
        sample = Sample.find_by_plot_id_and_sample_date(plot.id, s_date)

        if sample.nil? then
          sample = Sample.new

          sample.sample_date = s_date

          sample.plot = plot
          sample.sample_type = sample_type
          sample.save
        end

        # create a new measurement
        no3 = Measurement.new

        no3.analyte = analyte_no3
        if sample_type_id == 1
          no3.amount = $6
        else
          no3.amount = $5
        end
        no3.save
        sample.measurements << no3
        self.measurements << no3

        nh4 = Measurement.new
        nh4.analyte = analyte_nh4

        if sample_type_id == 1
          nh4.amount = $5
        else
          nh4.amount = $4
        end
        nh4.save

        sample.measurements << nh4
        self.measurements << nh4
      end

    end
end
