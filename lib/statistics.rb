# Helper class to compute simple statistics
class Statistics

  def Statistics.mean(data) 
    length = data.count
    return 0 unless length > 0
    sum = 0
    data.each { |var| sum += var }
    sum/length
  end

  def Statistics.variance(data)
    length = data.count
    return 0 unless length > 1
    mean = Statistics.mean(x)
    sum = 0.0
    data.each {|var| sum += (var - mean)**2 }
    sum/length
  end

  def Statistics.sigma(data)
    return 0 unless data.count > 1
    Math.sqrt(Statistics.variance(data))
  end
  
  def Statistics.cv(data)
    return 0 unless data.size > 1
    mean = Statistics.mean(data)
    return 100 if mean == 0
    Statistics.sigma(data)/mean*100    
  end

end
