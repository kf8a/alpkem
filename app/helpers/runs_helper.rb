require "#{Rails.root}/app/lib/statistics"

# Helper to display measurements
module RunsHelper
  def self.add_measurements(measurements, analyte1)
    chart_measurements = 'data.addRows(['
    measurements.each do |measurement|
      chart_measurements += add_measurement(measurement, analyte1)
    end
    chart_measurements
  end

  def self.add_measurement(m, analyte1)
    mdate = measurement_date(m)
    return unless mdate && m.amount

    if m.analyte == analyte1
      "[new Date(#{mdate.year}, #{mdate.month}, #{mdate.day}),"\
        " #{m.amount}, undefined],"
    else
      "[new Date(#{mdate.year}, #{mdate.month}, #{mdate.day}),"\
        " undefined, #{m.amount}],"
    end
  end

  def self.measurement_date(measurement)
    measurement.sample_date
  end

  def self.average(measurements)
    Statistics.mean(measurements.map(&:amount))
  end

  def self.cv_help(measurements)
    Statistics.cv(measurements.map(&:amount))
  end
end
