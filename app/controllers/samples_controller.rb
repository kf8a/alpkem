#Pages for showing/manipulating samples.
class SamplesController < ApplicationController

  before_filter :authenticate_user! unless Rails.env == 'test'
  require 'csv'

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
    @samples = Sample.approved_or_rejected.where('plots.name like ?',params[:q]+"%").page(params[:page]).per(500)
    render :index
  end

  def reject
    sample = Sample.find(params[:id])  
    sample.reject!
    render nothing: true
  end

  def approve
    sample = Sample.find(params[:id])  
    sample.approve!
    render nothing: true
  end

end
