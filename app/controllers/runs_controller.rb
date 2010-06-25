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

    #TODO: Sample_type_options has to be manually edited each time a new type is added. It could be refactored to eliminate this problem.
    @sample_type_options = [[sample_type_name(1), "1"],
                            [sample_type_name(2), "2"],
                            [sample_type_name(3), "3"],
                            [sample_type_name(4), "4"]]

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
    file = params[:data][:file]
    file_contents = StringIO.new(file.read)
    @run.load(file_contents)
    respond_to do |format|
      if @run.save
        flash[:notice] = 'Run was successfully uploaded.'
        format.html { redirect_to(@run) }
        format.xml  { render :xml => @run, :status => :created, :location => @run }
      else
        flash[:notice] = 'Run was not uploaded.'
        format.html { redirect_to :action => "new" } #TODO This is not ideal, since it does not tell you why it failed and all buttons are set to defaults.
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
  
  #TODO This exact same method is found in run.rb. Obviously should be refactored.
  def sample_type_name(id)
    if id == 1
      return "Lysimeter"
    elsif id == 2
      return "Soil Sample"
    elsif id == 3
      return "GLBRC Soil Sample"
    elsif id == 4
      return "GLBRC Deep Core"
    else
      return "Unknown Sample Type"
    end
  end
end
