#Allows the creation of studes, including plots, replicates, and treatments
class StudiesController < ApplicationController

  before_filter :get_study, :only => [:show, :edit, :update]

  respond_to :html, :xml

  def index
    @studies = Study.all
  end

  def new
    @study = Study.new
  end

  def create
    @study = Study.find_or_create_by_name(:name => params[:study_name], :prefix => params[:prefix])

    number_of_treatments = params[:number_of_treatments].to_i
    number_of_replicates = params[:number_of_replicates].to_i
    replicate_prefix = params[:replicate_prefix]

    @study.create_plots(number_of_treatments, number_of_replicates, replicate_prefix)
    respond_with @study
  end

  def show
  end

  def edit
  end

  def update
    if Replicate.find_by_study_id(@study)
      number_of_treatments = params[:number_of_treatments].to_i
      number_of_replicates = params[:number_of_replicates].to_i
      @study.update_plots(number_of_treatments, number_of_replicates)
    else
      flash[:notice] = "There are no replicates to update."
    end

    redirect_to :action => 'show', :id => @study.id
  end

  private#################################

  def get_study
    @study = Study.find(params[:id])
  end
end
