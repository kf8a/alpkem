class MeasurementsController < ApplicationController
  
  def destroy
    sample_class = params[:sample_class]
    if sample_class == "CnSample"
      @measurement = CnMeasurement.find(params[:id])
    else
      @measurement = Measurement.find(params[:id])
    end
    @measurement.toggle!(:deleted)
    dom_id = "sample_#{@measurement.sample.id}_#{@measurement.analyte.id}"
    @run = Run.find(params[:run_id])
    @measurements = @run.measurements + @run.cn_measurements
    render :update do |page|
      page.replace dom_id,
      :partial => 'runs/analyte',
      :locals => {:sample => @measurement.sample, :analyte => @measurement.analyte}
      page.visual_effect :highlight,  dom_id, :duration => 1
    end
  end
end
