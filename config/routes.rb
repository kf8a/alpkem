Alpkem::Application.routes.draw do
  devise_for :users

  resources :measurements

  resources :plots do
    collection do
      post 'create_plots'
      post 'update_plots'
    end
  end

  resources :runs do
    collection do
      get 'cn'
      post 'approve'
    end
  end

  resources :samples
  root :to => 'runs#index'
end