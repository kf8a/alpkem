require 'metric_fu'

MetricFu::Configuration.run do |config|
  #define what metrics you want to use
  config.metrics  = [:churn, :flay, :flog, :rails_best_practices, :reek, :roodi]
  config.graphs   = [:flay, :flog, :rails_best_practices, :reek, :roodi]

  config.flay = {   :dirs_to_flay => ['app', 'lib'],
                    :minimum_score => 0,
                    :filetypes => ['rb', 'erb'] }

end
