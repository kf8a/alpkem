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
    member do
      post 'approve'
      post 'reject'
    end
  end
  resources :studies

  root :to => 'runs#index'
end
