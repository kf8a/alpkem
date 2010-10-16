#Allows the creation of plots, including replicates, treatments, and studies
class PlotsController < ApplicationController

  before_filter :get_study, :only => [:show, :edit]

  def index
    @studies = Study.all
  end

  def new
  end

  def create_plots
    study = Study.find_or_create_by_name(:name => params[:study_name], :prefix => params[:prefix])
    
    number_of_treatments = params[:number_of_treatments].to_i
    1.upto(number_of_treatments) do |i|
      Treatment.find_or_create_by_name_and_study_id(:name => "#{study.prefix}#{i}", :study_id => study.id)
    end

    replicate_prefix = params[:replicate_prefix]
    number_of_replicates = params[:number_of_replicates].to_i
    1.upto(number_of_replicates) do |i|
      Replicate.find_or_create_by_name_and_study_id(:name => "#{replicate_prefix}#{i}", :study_id => study.id)
    end

    study.treatments.each do |treatment|
      replicates = Replicate.find_all_by_study_id(study)
      replicates.each do |replicate|
        p = Plot.find_or_create_by_name_and_study_id(:name => "#{treatment.name}#{replicate.name}", :study => study, :treatment => treatment, :replicate => replicate)
      end
    end
    redirect_to :action => 'show', :id => study.id
  end

  def show
  end

  def edit
  end

  def update_plots
    study = Study.find(params[:id])

    number_of_treatments = params[:number_of_treatments].to_i
    1.upto(number_of_treatments) do |i|
      Treatment.find_or_create_by_name_and_study_id(:name => "#{study.prefix}#{i}", :study_id => study.id)
    end

    replicate_prefix = Replicate.find_by_study_id(study).name[0,1]
    number_of_replicates = params[:number_of_replicates].to_i
    1.upto(number_of_replicates) do |i|
      Replicate.find_or_create_by_name_and_study_id(:name => "#{replicate_prefix}#{i}", :study_id => study.id)
    end

    study.treatments.each do |treatment|
      replicates = Replicate.find_all_by_study_id(study)
      replicates.each do |replicate|
        p = Plot.find_or_create_by_name_and_study_id(:name => "#{treatment.name}#{replicate.name}", :study => study, :treatment => treatment, :replicate => replicate)
      end
    end
    redirect_to :action => 'show', :id => study.id
  end

  private#################################

  def get_study
    @study = Study.find(params[:id])
  end
end
