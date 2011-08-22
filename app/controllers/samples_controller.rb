#Pages for showing/manipulating samples.
class SamplesController < ApplicationController
  
  require 'csv' or require 'fastercsv'

  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.approved
    respond_to do |format|
      format.html
      format.csv do
        csv_string = @samples ? Sample.samples_to_csv(@samples) : ""

        # send it to the browsah
        if csv_string.blank?
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
