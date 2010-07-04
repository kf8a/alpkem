class RunsController < ApplicationController
  
  before_filter :require_user if ::RAILS_ENV == 'production'
  
  # GET /runs
  # GET /runs.xml
  def index
    @runs = Run.find(:all, :order => 'sample_date')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @runs }
    end
  end
  
  # GET /runs/cn
  # GET /runs/cn.xml
  def cn
    @runs = Run.find(:all, :order => 'sample_date')
    
    respond_to do |format|
      format.html # cn.html.erb
      format.xml  { render :xml => @runs }
    end
  end

  # GET /runs/1
  # GET /runs/1.xml
  def show
    @run = Run.find(params[:id])
    @is_cn_run = @run.cn_measurements_exist

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @run }
    end
  end

  # GET /runs/new
  # GET /runs/new.xml
  def new
    @run = Run.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @run }
    end
  end

  # GET /runs/1/edit
  def edit
    @run        = Run.find(params[:id])
    if @run.cn_measurements_exist
      @samples = @run.cn_samples
    else @samples = @run.samples
    end
    @nh4        = Analyte.find_by_name('NH4')
    @no3        = Analyte.find_by_name('NO3')
    @percent_n  = Analyte.find_by_name('Percent N')
    @percent_c  = Analyte.find_by_name('Percent C')
  end

  # POST /runs
  # POST /runs.xml
  def create
    @run = Run.new(params[:run])
    if params[:data].blank?
      flash[:file_error] = 'No file was selected to upload.'
      render :action => "new" and return
    end
    file = params[:data][:file]
    if file.class == String
      flash[:file_error] = 'No file was selected to upload.'
      render :action => "new" and return
    end
    file_contents = StringIO.new(file.read)
    unless @run.load(file_contents)
      flash[:notice] = 'Load failed.'
      flash[:file_error] = @run.display_load_errors
      redirect_to :action => "new" and return
    end
    respond_to do |format|
      if @run.save
        flash[:notice] = 'Run was successfully uploaded.'
        format.html { redirect_to(@run) }
        format.xml  { render :xml => @run, :status => :created, :location => @run }
      else
        flash[:notice] = 'Run was not uploaded.'
        flash[:file_error] = @run.display_load_errors
        format.html { render :action => "new" }
        format.xml  { render :xml => @run.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /runs/1
  # PUT /runs/1.xml
  def update
    @run = Run.find(params[:id])

    respond_to do |format|
      if @run.update_attributes(params[:run])
        flash[:notice] = 'Run was successfully updated.'
        format.html { redirect_to(@run) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @run.errors, :status  => :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.xml
  def destroy
    @run = Run.find(params[:id])
    @run.destroy

    respond_to do |format|
      format.html { redirect_to(runs_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve
    sample = Sample.find(params[:id])
    sample.toggle(:approved)
    sample.save
    
    dom_id = "sample_#{sample.id}"
    nh4 = Analyte.find_by_name('NH4')
    no3 = Analyte.find_by_name('NO3')
    
    
    respond_to do |format|
      format.js do 
        render :update do |page|
          page.replace dom_id,
          :partial => 'runs/sample_data', 
          :locals => {:sample => sample, :no3 => no3, :nh4 => nh4}
          page.visual_effect :highlight,  dom_id, :duration => 1
        end
      end
      format.html { render :nothing => true }
      format.xml { head :ok }
    end
  end

end
