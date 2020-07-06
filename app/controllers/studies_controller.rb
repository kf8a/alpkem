# frozen_string_literal: true

# Allows the creation of studes, including plots, replicates, and treatments
class StudiesController < ApplicationController
  before_action :study, only: %i[edit update]

  respond_to :html, :xml

  def index
    @studies = Study.all
  end

  def new
    @study = Study.new
  end

  def create
    @study = Study.find_or_create_by(name: params[:study_name],
                                     prefix: params[:prefix])

    number_of_treatments = params[:number_of_treatments].to_i
    number_of_replicates = params[:number_of_replicates].to_i
    replicate_prefix = params[:replicate_prefix]

    @study.create_plots(number_of_treatments,
                        number_of_replicates,
                        replicate_prefix)
    respond_with @study
  end

  def show
    @study = Study.where(id: params[:id]).includes(:plots).first
  end

  def edit; end

  def update
    if Replicate.find_by(study_id: @study.id)
      number_of_treatments = params[:number_of_treatments].to_i
      number_of_replicates = params[:number_of_replicates].to_i
      @study.update_plots(number_of_treatments, number_of_replicates)
    else
      flash[:notice] = 'There are no replicates to update.'
    end

    redirect_to action: 'show', id: @study.id
  end

  private

  def study
    @study = Study.find(params[:id])
  end
end
