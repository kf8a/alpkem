#Methods to manipulate pages related to the Measurements model
class MeasurementsController < ApplicationController

  def destroy
    @run = Run.find(params[:run_id])
    @measurement = Measurement.find(params[:id])
    @measurement.toggle!(:deleted)
    @dom_id = "sample-#{@measurement.sample_id}-#{@measurement.analyte_id}"

    @measurements = @run.measurements
    respond_to do |format|
      format.js
    end
  end

end
