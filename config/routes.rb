ActionController::Routing::Routes.draw do |map|
  map.resources :measurements

  map.resources :plots
  
  map.resources :runs, :collection => { :cn => :get, :approve => :post }

  map.resources :samples

  map.resources :users

  map.resource :user_sessions
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "runs", :action => 'index'
  
  map.open_id_complete 'sessions', :controller => "sessions", :action => "create", :requirements => { :method => :get }
end
