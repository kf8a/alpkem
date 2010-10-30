require 'metric_fu'

MetricFu::Configuration.run do |config|
  #define what metrics you want to use
  config.metrics  = [:flay, :flog, :rails_best_practices, :reek, :roodi]
  config.graphs   = [:flay, :flog, :rails_best_practices, :reek, :roodi]
end
