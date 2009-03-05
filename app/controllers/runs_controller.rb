class RunsController < ApplicationController
  # GET /runs
  # GET /runs.xml
  def index
    @runs = Run.find(:all, :order => 'sample_date')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @runs }
    end
  end

  # GET /runs/1
  # GET /runs/1.xml
  def show
    @run = Run.find(params[:id])

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
    @run = Run.find(params[:id])
    @samples = @run.samples 
    @nh4 = Analyte.find_by_name('NH4')
    @no3 = Analyte.find_by_name('NO3')
  end

  # POST /runs
  # POST /runs.xml
  def create
    @run = Run.new(params[:run])

    respond_to do |format|
      if @run.save
        @run.load(params[:data][:file],@run.sample_type_id)
        flash[:notice] = 'Run was successfully uploaded.'
        format.html { redirect_to(@run) }
        format.xml  { render :xml => @run, :status => :created, :location => @run }
      else
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
        format.xml  { render :xml => @run.errors, :status => :unprocessable_entity }
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
    render :nothing => true
  end
end
