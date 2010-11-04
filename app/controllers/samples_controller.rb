class SamplesController < ApplicationController
  
  require 'csv' or require 'fastercsv'

  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.approved
    respond_to do |format|
      format.html
      format.csv do
        no3 = Analyte.find_by_name('NO3')
        nh4 = Analyte.find_by_name('NH4')
        
        unless @samples.blank?
          csv_string = CSV.generate do |csv|
            csv << ['sample_id','sample_date','treatment','replicate','no3_ppm','nh4_ppm']
            @samples.each do |sample|
              csv <<  [sample.id, 
                       sample.sample_date.to_s, 
                       sample.plot.treatment.name, 
                       sample.plot.replicate.name, 
                       sample.average(no3), 
                       sample.average(nh4)]
            end
          end
        end
        # send it to the browsah
        if csv_string.nil?
          csv_string = "no data"
          send_data csv_string, :type => 'text'
        else
          send_data csv_string,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=samples.csv"
        end
      end
    end
  end

end
