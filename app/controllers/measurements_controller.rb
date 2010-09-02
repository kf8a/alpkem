class MeasurementsController < ApplicationController
  before_filter :require_user if ::RAILS_ENV == 'production'
  
  def destroy
    sample_class = params[:sample_class]
    if sample_class == "CnSample"
      @m = CnMeasurement.find(params[:id])
    else
      @m = Measurement.find(params[:id])
    end
    @m.toggle!(:deleted)
    dom_id = "sample_#{@m.sample.id}_#{@m.analyte.id}"
    render :update do |page|
      page.replace dom_id,
      :partial => 'runs/analyte',
      :locals => {:sample => @m.sample, :analyte => @m.analyte}
      page.visual_effect :highlight,  dom_id, :duration => 1
    end
  end
end
