require File.dirname(__FILE__) + '/../../test_helper'

class RunsHelperTest < ActionView::TestCase

  def setup
    @analyte1 = Factory.create(:analyte, 
                                :name => "C6H12O6", 
                                :unit => "sweetness")
                                
    @analyte2 = Factory.create(:analyte, 
                                :name => "NaCl", 
                                :unit => "saltiness")
    
    @measurement1_date    = Date.today
    @measurement1_amount  = 0.0235
    @measurement1         = Factory.create(:measurement, 
                                    :amount => @measurement1_amount, 
                                    :analyte => @analyte1, 
                                    :sample => Factory.create(:sample, 
                                    :sample_date => @measurement1_date))
    
    @measurement2_date    = Date.today.prev_year
    @measurement2_amount  = 0.001
    @measurement2         = Factory.create(:measurement, 
                                    :amount => @measurement2_amount, 
                                    :analyte => @analyte1, 
                                    :sample => Factory.create(:sample, 
                                    :sample_date => @measurement2_date))
    
    @measurement3_date    = Date.yesterday
    @measurement3_amount  = -0.089
    @measurement3         = Factory.create(:measurement, 
                                    :amount => @measurement3_amount, 
                                    :analyte => @analyte1, 
                                    :sample => Factory.create(:sample, 
                                    :sample_date => @measurement3_date))
    
    @measurement4_date    = Date.today.prev_month
    @measurement4_amount  = -0.875
    @measurement4         = Factory.create(:measurement, 
                                    :amount => @measurement4_amount, 
                                    :analyte => @analyte2, 
                                    :sample => Factory.create(:sample, 
                                    :sample_date => @measurement4_date))
    
    @measurement5_date    = Date.today - 450
    @measurement5_amount  = 0.0
    @measurement5         = Factory.create(:measurement, 
                                    :amount => @measurement5_amount, 
                                    :analyte => @analyte2, 
                                    :sample => Factory.create(:sample, 
                                    :sample_date => @measurement5_date))
    
    @measurement6_date    = Date.today
    @measurement6_amount  = 0.8
    @measurement6         = Factory.create(:measurement, 
                                    :amount => @measurement6_amount, 
                                    :analyte => @analyte2, 
                                    :sample => Factory.create(:sample, 
                                    :sample_date => @measurement6_date))  
  end
  
  test "makes the right google chart script" do
    @measurements     = [@measurement1, @measurement2, @measurement3,
                         @measurement4, @measurement5, @measurement6]
                     
    @analytes         = [@analyte1, @analyte2]

    proper_chart_script  =
      "data.addColumn('date', 'Date');" +
      "data.addColumn('number', '#{@analyte1.name}');" +
      "data.addColumn('number', '#{@analyte2.name}');" +
      "data.addRows([" +
        "[new Date(#{@measurement1_date.year}, #{@measurement1_date.month}, #{@measurement1_date.day}), #{@measurement1_amount}, undefined]," +
        "[new Date(#{@measurement2_date.year}, #{@measurement2_date.month}, #{@measurement2_date.day}), #{@measurement2_amount}, undefined]," +
        "[new Date(#{@measurement3_date.year}, #{@measurement3_date.month}, #{@measurement3_date.day}), #{@measurement3_amount}, undefined]," +
        "[new Date(#{@measurement4_date.year}, #{@measurement4_date.month}, #{@measurement4_date.day}), undefined, #{@measurement4_amount}]," +
        "[new Date(#{@measurement5_date.year}, #{@measurement5_date.month}, #{@measurement5_date.day}), undefined, #{@measurement5_amount}]," +
        "[new Date(#{@measurement6_date.year}, #{@measurement6_date.month}, #{@measurement6_date.day}), undefined, #{@measurement6_amount}]" +
        "]);"

    assert_equal proper_chart_script,
                  google_chart_script_helper(@measurements, @analytes)
  end
  
  test "should not crash if there is no analyte2 amounts" do
    @measurements = [@measurement1, @measurement2, @measurement3]

    @analytes = [@analyte1, @analyte2]

    assert google_chart_script_helper(@measurements, @analytes)
  end

  test "should make a google chart script with all the measurements even when they are unbalanced" do

    @measurements     = [@measurement1, @measurement2,
                         @measurement4, @measurement5, @measurement6]

    @analytes         = [@analyte1, @analyte2]

    proper_chart_script  =
      "data.addColumn('date', 'Date');" +
      "data.addColumn('number', '#{@analyte1.name}');" +
      "data.addColumn('number', '#{@analyte2.name}');" +
      "data.addRows([" +
        "[new Date(#{@measurement1_date.year}, #{@measurement1_date.month}, #{@measurement1_date.day}), #{@measurement1_amount}, undefined]," +
        "[new Date(#{@measurement2_date.year}, #{@measurement2_date.month}, #{@measurement2_date.day}), #{@measurement2_amount}, undefined]," +
        "[new Date(#{@measurement4_date.year}, #{@measurement4_date.month}, #{@measurement4_date.day}), undefined, #{@measurement4_amount}]," +
        "[new Date(#{@measurement5_date.year}, #{@measurement5_date.month}, #{@measurement5_date.day}), undefined, #{@measurement5_amount}]," +
        "[new Date(#{@measurement6_date.year}, #{@measurement6_date.month}, #{@measurement6_date.day}), undefined, #{@measurement6_amount}]" +
        "]);"

    assert_equal proper_chart_script, google_chart_script_helper(@measurements, @analytes)
  end
end
