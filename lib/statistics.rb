# Helper class to compute simple statistics
class Statistics

  def Statistics.mean(data) 
    length = data.count
    return 0 unless length > 0
    sum = data.reduce(0.0, :+)
    sum/length
  end

  def Statistics.variance(data)
    length = data.count
    return 0 unless length > 1
    mean = Statistics.mean(data)
    sum = data.reduce(0.0) {|memo, var| memo + (var - mean)**2 }
    sum/length
  end

  def Statistics.sigma(data)
    Math.sqrt(Statistics.variance(data))
  end
  
  def Statistics.cv(data)
    return 0 unless data.size > 1
    mean = Statistics.mean(data)
    return 100 if mean == 0
    Statistics.sigma(data)/mean*100    
  end

end
