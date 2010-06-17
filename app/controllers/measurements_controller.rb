class MeasurementsController < ApplicationController
  before_filter :require_user if ::RAILS_ENV == 'production'
  
  def destroy
    m = Measurement.find(params[:id])
    p 'in'
    m.toggle!(:deleted)
    sample = m.sample
    dom_id = "sample_#{sample.id}_#{m.analyte.id}"
    render :update do |page|
      page.replace dom_id,
      :partial => 'runs/analyte', 
      :locals => {:sample => sample, :analyte => m.analyte}
      page.visual_effect :highlight,  dom_id, :duration => 1
    end
  end
end
