# This is the main controller for the app. Pages to show/manipulate runs.
class RunsController < ApplicationController
  before_action :run, only: [:qc, :edit, :update, :destroy]
  respond_to :html, :csv

  # GET /runs
  def index
    @runs = Run.runs
    respond_with @runs
  end

  # GET /runs/cn
  def cn
    @runs = Run.cn_runs
    respond_with @runs
  end

  # GET /runs/1
  def show
    @run = Run.includes(:measurements).find(params[:id])
    @back = @run.cn_run? ? cn_runs_path : runs_path
    respond_with @run
  end

  # GET /runs/new
  def new
    @run = Run.new
    @run.sample_date  = Time.zone.today # session[:sample_date]
    @run.run_date     = session[:run_date]
    @run.sample_type_id = session[:sample_type_id]
    respond_with @run
  end

  def edit
  end

  # GET /runs/1/qc
  def qc
    @samples    = @run.samples.order('id')
    @analytes   = @run.analytes
    # @measurements = @run.all_measurements +
    # @run.similar_runs.collect{|run| run.all_measurements}
  end

  # POST /runs
  def create
    @run = Run.new(run_params)

    session[:sample_date] = @run.sample_date
    session[:run_date] = @run.run_date
    session[:sample_type_id] = @run.sample_type_id

    if params[:data] && params[:data].present?
      data_source = DataSource.new
      data_source.data = params[:data][:file]
      @run.data_sources << data_source
      data_source.save
      @run.load_file(params[:data][:file])
    end

    if @run.save
      flash[:notice] = 'Run was successfully uploaded.'
    else
      flash[:notice] = 'Run was not uploaded.'
      flash[:file_error] = @run.load_errors
    end
    flash[:notice] += @run.plot_errors

    respond_with @run
  end

  # PUT /runs/1
  def update
    # if @run.update_attributes(run_params) &&  @run.update_sample_types
    #   flash[:notice] = 'Run was successfully updated.'
    # end
    respond_with @run
  end

  # DELETE /runs/1
  # DELETE /runs/1.xml
  def destroy
    @run.destroy
    respond_with @run
  end

  def approve
    @run = Run.find(params[:run_id])
    @measurements = @run.all_measurements
    @sample = Sample.find(params[:id])
    @sample.toggle_approval

    @dom_id     = "sample-#{@sample.id}"
    @analytes   = @run.analytes

    respond_to do |format|
      format.js
      format.html { render nothing: true }
      format.xml { head :ok }
    end
  end

  private

  def run
    @run = Run.find(params[:id])
  end

  def run_params
    params.require(:run).permit(:run_date, :sample_date, :start_date,
                                :initial_sample_date, :sample_type_id,
                                :comment)
  end
end
