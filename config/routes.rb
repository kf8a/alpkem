Alpkem::Application.routes.draw do
  devise_for :users

  resources :measurements

  resources :runs do
    collection do
      get 'cn'
      post 'approve'
    end
  end

  resources :samples
  resources :studies

  root :to => 'runs#index'
end