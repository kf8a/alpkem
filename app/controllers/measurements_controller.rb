class MeasurementsController < ApplicationController
  
  def destroy
    @run = Run.find(params[:run_id])
    @measurement = @run.measurement_by_id(params[:id])
    @measurement.toggle!(:deleted)
    dom_id = "sample_#{@measurement.sample.id}_#{@measurement.analyte.id}"
    
    @measurements = @run.measurements + @run.cn_measurements
    render :update do |page|
      page.replace dom_id,
      :partial => 'runs/analyte',
      :locals => {:sample => @measurement.sample, :analyte => @measurement.analyte}
      page.visual_effect :highlight,  dom_id, :duration => 1
    end
  end
end
