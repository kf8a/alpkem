require 'test_helper'

class RunsHelperTest < ActionView::TestCase

  test "makes the right google chart url" do
    analyte1 = Factory.create(:analyte, :name => "C6H12O6", :unit => "sweetness")
    analyte2 = Factory.create(:analyte, :name => "NaCl", :unit => "saltiness")
    
    measurement1_date = Date.today
    measurement1_amount = 0.0235
    @measurement1 = Factory.create(:measurement, :amount => measurement1_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement1_date))
    
    measurement2_date = Date.today.last_year
    measurement2_amount = 0.001
    @measurement2 = Factory.create(:measurement, :amount => measurement2_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement2_date))
    
    measurement3_date = Date.yesterday
    measurement3_amount = -0.089
    @measurement3 = Factory.create(:measurement, :amount => measurement3_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement3_date))
    
    measurement4_date = Date.today.last_month
    measurement4_amount = -0.875
    @measurement4 = Factory.create(:measurement, :amount => measurement4_amount, :analyte => analyte2, :sample => Factory.create(:sample, :sample_date => measurement4_date))
    
    measurement5_date = Date.today - 450
    measurement5_amount = 0.0
    @measurement5 = Factory.create(:measurement, :amount => measurement5_amount, :analyte => analyte2, :sample => Factory.create(:sample, :sample_date => measurement5_date))
    
    measurement6_date = Date.today
    measurement6_amount = 0.8
    @measurement6 = Factory.create(:measurement, :amount => measurement6_amount, :analyte => analyte2, :sample => Factory.create(:sample, :sample_date => measurement6_date))
    
    @measurements = [@measurement1, @measurement2, @measurement3, @measurement4, @measurement5, @measurement6]
    @analytes = [analyte1, analyte2]

    proper_chart_url = "http://chart.apis.google.com/chart?cht=s&chd=t:" + measurement1_date.jd.to_s + "," + measurement4_date.jd.to_s + "," + measurement2_date.jd.to_s + "," + measurement5_date.jd.to_s + "," + measurement3_date.jd.to_s + "," + measurement6_date.jd.to_s + "|" + measurement1_amount.to_s + "," + measurement4_amount.to_s + "," + measurement2_amount.to_s + "," + measurement5_amount.to_s + "," + measurement3_amount.to_s + "," + measurement6_amount.to_s + "|1,1,1,1,1,1&chs=250x200&chdl=" + analyte1.name + "|" + analyte2.name + "&chxt=x,y&chxr=0," + measurement5_date.year.to_s + "," + measurement6_date.year.to_s + ",1|1," + measurement4_amount.to_s + "," + measurement6_amount.to_s + ",0.335&chds=" + measurement5_date.jd.to_s + "," + measurement6_date.jd.to_s + "," + measurement4_amount.to_s + "," + measurement6_amount.to_s + "&chtt=Approved+measurements&chco=FF0000|0000FF"

    assert_equal proper_chart_url, google_chart_url_maker(@measurements, @analytes)
  end
  
  test "should not crash if there is no analyte2 amounts" do
    analyte1 = Factory.create(:analyte, :name => "C6H12O6", :unit => "sweetness")
    analyte2 = Factory.create(:analyte, :name => "NaCl", :unit => "saltiness")
    
    measurement1_date = Date.today
    measurement1_amount = 0.0235
    @measurement1 = Factory.create(:measurement, :amount => measurement1_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement1_date))
    
    measurement2_date = Date.today.last_year
    measurement2_amount = 0.001
    @measurement2 = Factory.create(:measurement, :amount => measurement2_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement2_date))
    
    measurement3_date = Date.yesterday
    measurement3_amount = -0.089
    @measurement3 = Factory.create(:measurement, :amount => measurement3_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement3_date))
    
    @measurements = [@measurement1, @measurement2, @measurement3]
    @analytes = [analyte1, analyte2]

    assert google_chart_url_maker(@measurements, @analytes)
  end
  
  test "should make a google chart url with all the measurements even when they are unbalanced" do
    analyte1 = Factory.create(:analyte, :name => "C6H12O6", :unit => "sweetness")
    analyte2 = Factory.create(:analyte, :name => "NaCl", :unit => "saltiness")
    
    measurement1_date = Date.today
    measurement1_amount = 0.0235
    @measurement1 = Factory.create(:measurement, :amount => measurement1_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement1_date))
    
    measurement2_date = Date.today.last_year
    measurement2_amount = 0.001
    @measurement2 = Factory.create(:measurement, :amount => measurement2_amount, :analyte => analyte1, :sample => Factory.create(:sample, :sample_date => measurement2_date))
    
    measurement4_date = Date.today.last_month
    measurement4_amount = -0.875
    @measurement4 = Factory.create(:measurement, :amount => measurement4_amount, :analyte => analyte2, :sample => Factory.create(:sample, :sample_date => measurement4_date))
    
    measurement5_date = Date.today - 450
    measurement5_amount = 0.0
    @measurement5 = Factory.create(:measurement, :amount => measurement5_amount, :analyte => analyte2, :sample => Factory.create(:sample, :sample_date => measurement5_date))
    
    measurement6_date = Date.today
    measurement6_amount = 0.8
    @measurement6 = Factory.create(:measurement, :amount => measurement6_amount, :analyte => analyte2, :sample => Factory.create(:sample, :sample_date => measurement6_date))
    
    @measurements = [@measurement1, @measurement2, @measurement4, @measurement5, @measurement6]
    @analytes = [analyte1, analyte2]

    proper_chart_url = "http://chart.apis.google.com/chart?cht=s&chd=t:" + measurement1_date.jd.to_s + "," + measurement4_date.jd.to_s + "," + measurement2_date.jd.to_s + "," + measurement5_date.jd.to_s + "," + "4," + measurement6_date.jd.to_s + "|" + measurement1_amount.to_s + "," + measurement4_amount.to_s + "," + measurement2_amount.to_s + "," + measurement5_amount.to_s + "," + "1000," + measurement6_amount.to_s + "|1,1,1,1,0,1&chs=250x200&chdl=" + analyte1.name + "|" + analyte2.name + "&chxt=x,y&chxr=0," + measurement5_date.year.to_s + "," + measurement6_date.year.to_s + ",1|1," + measurement4_amount.to_s + "," + measurement6_amount.to_s + ",0.335&chds=" + measurement5_date.jd.to_s + "," + measurement6_date.jd.to_s + "," + measurement4_amount.to_s + "," + measurement6_amount.to_s + "&chtt=Approved+measurements&chco=FF0000|0000FF"

    assert_equal proper_chart_url, google_chart_url_maker(@measurements, @analytes)
  end
end
