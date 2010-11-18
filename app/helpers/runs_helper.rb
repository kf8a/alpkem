require 'statistics'

module RunsHelper

  def self.google_chart_script_helper(measurements, analytes)
    analyte1 = analytes[0]
    analyte2 = analytes[1]
    
    chart_script = setup_columns(analyte1, analyte2)
    chart_script += add_measurements(measurements, analyte1)
    chart_script.slice!(-1) if chart_script.end_with?(",")
    chart_script += "]);"
  end

  def self.setup_columns(analyte1, analyte2)
    "data.addColumn('date', 'Date');" +
    "data.addColumn('number', '#{analyte1.name}');" +
    "data.addColumn('number', '#{analyte2.name}');"
  end

  def self.add_measurements(measurements, analyte1)
    chart_measurements = "data.addRows(["
    measurements.each do |measurement|
      chart_measurements += add_measurement(measurement, analyte1)
    end
    chart_measurements
  end

  def self.add_measurement(m, analyte1)
    mdate = measurement_date(m)
    if mdate && m.amount
      if m.analyte == analyte1
        "[new Date(#{mdate.year}, #{mdate.month}, #{mdate.day}), #{m.amount}, undefined],"
      else
        "[new Date(#{mdate.year}, #{mdate.month}, #{mdate.day}), undefined, #{m.amount}],"
      end
    end
  end

  def self.measurement_date(measurement)
    measurement.sample.try(:sample_date)
  end

  def self.average(measurements)
    Statistics.mean(measurements.map {|x| x.amount})
  end

  def self.cv_help(measurements)
    Statistics.cv(measurements.map {|x| x.amount})
  end
end
