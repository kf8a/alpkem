# frozen_string_literal: true

# Helper class to compute simple statistics
class Statistics
  def self.mean(data)
    length = data.count
    return 0 unless length.positive?

    sum = data.reduce(0.0, :+)
    sum / length
  end

  def self.variance(data)
    length = data.count
    return 0 unless length > 1

    mean = Statistics.mean(data)
    sum = data.reduce(0.0) { |memo, var| memo + (var - mean)**2 }
    sum / length
  end

  def self.sigma(data)
    Math.sqrt(Statistics.variance(data))
  end

  def self.cv(data)
    return 0 unless data.size > 1

    mean = Statistics.mean(data)
    return 100 if mean.zero?

    sigma(data) / mean * 100
  end
end
