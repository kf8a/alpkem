class MeasurementsController < ApplicationController
  before_filter :require_user if ::RAILS_ENV == 'production'
  
  def destroy
    sample_class = params[:sample_class]
    if sample_class == "CnSample"
      @m = CnMeasurement.find(params[:id])
      sample = @m.cn_sample
    else
      @m = Measurement.find(params[:id])
      sample = @m.sample
    end
    @m.toggle!(:deleted)
    dom_id = "sample_#{sample.id}_#{@m.analyte.id}"
    render :update do |page|
      page.replace dom_id,
      :partial => 'runs/analyte', 
      :locals => {:sample => sample, :analyte => @m.analyte}
      page.visual_effect :highlight,  dom_id, :duration => 1
    end
  end
end
