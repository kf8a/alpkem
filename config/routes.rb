Alpkem::Application.routes.draw do
  resources :measurements

  resources :plots do
    collection do
      post :create_plots
      post :update_plots
    end
  end

  resources :runs do
    collection do
      get :cn
      post :approve
    end
  end

  resources :samples
  resources :users
  resource :user_sessions
  match '/' => 'runs#index'
  #match 'sessions' => 'sessions#create', :as => :open_id_complete, :constraints => { :method => get }
end