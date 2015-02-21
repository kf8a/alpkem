#Pages for showing/manipulating samples.
class SamplesController < ApplicationController

  before_filter :authenticate_user! unless Rails.env == 'test'
  require 'csv'

  respond_to :html, :json, :csv

  # GET /samples
  # GET /samples.xml
  def index
    @samples = Sample.approved_or_rejected.page(params[:page]).per(100)
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

  def search
    @q = params[:q]
    @samples = Sample.approved_or_rejected.where('plots.name like ?',@q+"%").page(params[:page]).per(500)
    render :index
  end

  def toggle
    @sample = Sample.find(params[:id])
    analyte = Analyte.where(name: params[:analyte]).first
    @sample.measurements.where(analyte_id: analyte.id).each do |measurement|
      measurement.rejected = measurement.rejected ^true
      measurement.save
    end 
    @dom_id = "sample-" + @sample.id.to_s
    respond_to do |format|
      format.js
    end
  end

end
