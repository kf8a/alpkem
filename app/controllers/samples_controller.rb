require 'fastercsv'

class SamplesController < ApplicationController
  
  before_filter :require_user
  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.find_approved
    respond_to do |format|
      format.csv do
        no3 = Analyte.find_by_name('NO3')
        nh4 = Analyte.find_by_name('NH4')

        csv_string = FasterCSV.generate do |csv|
          csv << ['sample_id','sample_date','treatment','replicate','no3_ppm','nh4_ppm']
          @samples.each do |s|
            csv <<  [s.id, s.sample_date.to_s, s.plot.treatment.name, s.plot.replicate.name, s.average(no3), s.average(nh4)]
          end
        end
        # send it to the browsah
        send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=samples.csv"
        
      end
    end
  end

end
