# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# require 'rack'
# require 'prometheus/middleware/collector'
# require 'prometheus/middleware/exporter'
#
# use Prometheus::Client::Rack::Collector
# use Prometheus::Client::Rack::Exporter

run Alpkem::Application
