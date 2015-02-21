Alpkem::Application.routes.draw do
  devise_for :users

  resources :measurements

  resources :runs do
    member do
      get 'qc'
    end
    collection do
      get 'cn'
      post 'approve'
    end
  end

  resources :samples do
    collection do
      get 'search'
    end
    member do
      post 'toggle'
    end
  end
  resources :studies

  root :to => 'runs#index'
end
