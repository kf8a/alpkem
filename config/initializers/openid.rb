Alpkem::Application.config.middleware.insert_before(Warden::Manager, Rack::OpenID)
