module RunsHelper

  def google_chart_url_maker(measurements, analytes)
    previous_dates = ""
    analyte1_dates = []
    analyte2_dates = []
    earliest_date = Date.today.prev_year
    previous_amounts = ""
    analyte1_amounts = []
    analyte2_amounts = []
    lowest_amount = 0
    highest_amount = 0
    analyte1 = analytes[0]
    analyte2 = analytes[1]
    chart_marker_sizes = ""
    measurements.each do |m|
      earliest_date     = [earliest_date, m.sample.sample_date].min
      highest_amount    = [highest_amount, m.amount].max
      lowest_amount     = [lowest_amount, m.amount].min
      analyte1_amounts  << m.amount.to_s + "," if m.analyte == analyte1
      analyte1_dates    << m.sample.sample_date.jd.to_s + "," if m.analyte == analyte1
      analyte2_amounts  << m.amount.to_s + "," if m.analyte == analyte2
      analyte2_dates    << m.sample.sample_date.jd.to_s + "," if m.analyte == analyte2
    end
    [analyte1_amounts.size, analyte2_amounts.size].max.times do |a|
      if analyte1_amounts[a]
        analyte1_amount = analyte1_amounts[a]
        analyte1_date = analyte1_dates[a]
        analyte1_size = "1,"
      else
        #fake data, but put in at 0 size
        analyte1_amount = "1000,"
        analyte1_date = "4,"
        analyte1_size = "0,"
      end
      
      if analyte2_amounts[a]
        analyte2_amount = analyte2_amounts[a]
        analyte2_date = analyte2_dates[a]
        analyte2_size = "1,"
      else
        analyte2_amount = "1000,"
        analyte2_date = "4,"
        analyte2_size = "0,"
      end
      
      previous_amounts += analyte1_amount + analyte2_amount
      previous_dates   += analyte1_date + analyte2_date
      chart_marker_sizes += analyte1_size + analyte2_size
    end
    date_step = [((Date.today.year - earliest_date.year)/4), 1].max
    previous_dates.slice!(-1) if previous_dates.end_with?(",")
    previous_amounts.slice!(-1) if previous_amounts.end_with?(",")
    chart_marker_sizes.slice!(-1) if chart_marker_sizes.end_with?(",")
    chart_step         = (highest_amount - lowest_amount)/5
    chart_type         = "s" #scatterplot
    chart_width        = "250"
    chart_height       = "200"
    chart_legend       = analyte1.name.delete(" ") + "|" + analyte2.name.delete(" ")
    chart_x_values     = previous_dates
    chart_y_values     = previous_amounts
    chart_visible_axes = "x,y"
    chart_x_axis_range = earliest_date.year.to_s + "," + Date.today.year.to_s + "," + date_step.to_s
    chart_y_axis_range = lowest_amount.to_s + "," + highest_amount.to_s + "," + chart_step.to_s
    chart_data_range   = earliest_date.jd.to_s + "," + Date.today.jd.to_s + "," + lowest_amount.to_s + "," + highest_amount.to_s
    chart_title        = "Approved+measurements"
    chart_colors       = "FF0000|0000FF"
    chart_numeric_y_range= highest_amount - lowest_amount
    point_size         = chart_numeric_y_range < 1 ? 4 : ((chart_height.to_i)/(chart_numeric_y_range) * 40)
    
    google_chart_url = "http://chart.apis.google.com/chart?cht=" + chart_type + "&chd=t:" + chart_x_values + "|" + chart_y_values + "|" + chart_marker_sizes + "&chs=" + chart_width + "x" + chart_height + "&chdl=" + chart_legend + "&chxt=" + chart_visible_axes + "&chxr=0," + chart_x_axis_range + "|1," + chart_y_axis_range + "&chds=" + chart_data_range + "&chtt=" + chart_title + "&chco=" + chart_colors + "&chm=o,FF0000,#{point_size}|o,0000FF,#{point_size}"
    return google_chart_url
  end
end
