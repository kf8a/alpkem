ActionController::Routing::Routes.draw do |map|
  map.resources :measurements

  map.resources :samples

  map.resources :runs

  map.resources :users

  map.resource :user_sessions
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "runs", :action => 'index'
  
  map.open_id_complete 'sessions', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
