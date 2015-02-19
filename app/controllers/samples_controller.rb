#Pages for showing/manipulating samples.
class SamplesController < ApplicationController

  before_filter :authenticate_user! unless Rails.env == 'test'
  require 'csv'

  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.approved.order('sample_date desc').joins(:plot).order('plots.name').joins(measurements: :analyte).page(params[:page]).per(100)
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

  def reject
  end

  def approve
  end
end
