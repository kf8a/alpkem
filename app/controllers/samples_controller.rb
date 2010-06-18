class SamplesController < ApplicationController
  
  require 'csv' or require 'fastercsv'

  before_filter :require_user if ::RAILS_ENV == 'production'
  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.find_approved
    respond_to do |format|
      format.html
      format.csv do
        no3 = Analyte.find_by_name('NO3')
        nh4 = Analyte.find_by_name('NH4')
        
        if @samples.blank?
#          csv_string = CSV.generate do |csv|
#            csv << ['No_valid_samples', 'really']
#          end
        else
          csv_string = CSV.generate do |csv|
            csv << ['sample_id','sample_date','treatment','replicate','no3_ppm','nh4_ppm']
            @samples.each do |s|
              csv <<  [s.id, s.sample_date.to_s, s.plot.treatment.name, s.plot.replicate.name, s.average(no3), s.average(nh4)]
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
