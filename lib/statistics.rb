class Statistics

  def Statistics.mean(x) 
    return 0 unless x.size > 0
    sum = 0
    x.each { |v| sum += v }
    sum/x.size
  end

  def Statistics.variance(x)
    return 0 unless x.size > 1
    m = Statistics.mean(x)
    sum = 0.0
    x.each {|v| sum += (v - m)**2 }
    sum/x.size
  end

  def Statistics.sigma(x)
    return 0 unless x.size > 1
    Math.sqrt(Statistics.variance(x))
  end
  
  def Statistics.cv(x)
    return 0 unless x.size > 1
    return 100 if Statistics.mean(x) == 0
    Statistics.sigma(x)/Statistics.mean(x)*100    
  end

end
