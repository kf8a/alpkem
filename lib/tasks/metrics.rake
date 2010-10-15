require 'metric_fu'

MetricFu::Configuration.run do |config|
  #define what metrics you want to use
  config.metrics  = [:flay, :rails_best_practices, :reek, :roodi]
  config.graphs   = [:flay, :rails_best_practices, :reek, :roodi]
end
