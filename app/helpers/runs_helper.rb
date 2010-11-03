require 'statistics'

module RunsHelper

  def google_chart_script_helper(measurements, analytes)
    analyte1 = analytes[0]
    analyte2 = analytes[1]
    
    chart_script = "data.addColumn('date', 'Date');" +
                   "data.addColumn('number', '#{analyte1.name}');" +
                   "data.addColumn('number', '#{analyte2.name}');" +
                   "data.addRows(["

    measurements.each do |m|
      next unless m.sample and m.sample.sample_date and m.amount
      mdate = m.sample.sample_date
      if m.analyte == analyte1
        chart_script += "[new Date(#{mdate.year}, #{mdate.month}, #{mdate.day}), #{m.amount}, undefined],"
      else
        chart_script += "[new Date(#{mdate.year}, #{mdate.month}, #{mdate.day}), undefined, #{m.amount}],"
      end
    end

    chart_script.slice!(-1) if chart_script.end_with?(",")
    chart_script += "]);"

    chart_script
  end

  def average(measurements)
    members = measurements.count
    if members > 0
      total = 0
      measurements.each do |measurement|
        total += measurement.amount
      end
      total / members
    end
  end

  def cv_help(measurements)
    Statistics.cv(measurements.map {|x| x.amount})
  end
end
