#This is the main controller for the app. Pages to show/manipulate runs.
class RunsController < ApplicationController
  
  before_filter :get_run, :only => [:edit, :update, :destroy]
  respond_to :html, :xml
  
  # GET /runs
  # GET /runs.xml
  def index
    @runs = Run.runs
    respond_with @runs
  end
  
  # GET /runs/cn
  # GET /runs/cn.xml
  def cn
    @runs = Run.cn_runs
    respond_with @runs
  end

  # GET /runs/1
  # GET /runs/1.xml
  def show
    @run = Run.includes(:measurements).find(params[:id])
    @back = if @run.cn_run? then cn_runs_path else runs_path end
    respond_with @run
  end

  # GET /runs/new
  # GET /runs/new.xml
  def new
    @run = Run.new
    @run.sample_date  = session[:sample_date]
    @run.run_date     = session[:run_date]
    respond_with @run
  end

  # GET /runs/1/edit
  def edit
    @samples    = @run.samples.order('id')
    @analytes   = @run.analytes
    @measurements = @run.measurements.includes(:sample).includes(:analyte) +
        @run.cn_measurements.includes(:cn_sample).includes(:analyte)
  end

  # POST /runs
  # POST /runs.xml
  def create
    @run = Run.new(params[:run])

    session[:sample_date] = @run.sample_date
    session[:run_date] = @run.run_date
    
    file = (!params[:data].blank? && params[:data][:file])
    @run.load_file(file)

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
  # PUT /runs/1.xml
  def update
    if @run.update_attributes(params[:run])
      flash[:notice] = 'Run was successfully updated.'
    end
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
    @measurements = @run.measurements.includes(:sample).includes(:analyte) +
        @run.cn_measurements.includes(:cn_sample).includes(:analyte)
    @sample = @run.sample_by_id(params[:id])
    @sample.toggle(:approved)
    @sample.save
    
    dom_id      = "sample_#{@sample.id}"
    @analytes   = @run.analytes
    
    respond_to do |format|
      format.js do 
        render :update do |page|
          page.replace dom_id,
          :partial => 'runs/sample', 
          :locals => {:sample => @sample}
          page.visual_effect :highlight,  dom_id, :duration => 1
        end
      end
      format.html { render :nothing => true }
      format.xml { head :ok }
    end
  end

  private###############################

  def get_run
    @run = Run.find(params[:id])
  end

end
