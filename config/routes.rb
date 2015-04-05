TimelineRails::Application.routes.draw do
  root to: 'events#index'
  
  resources :users do
    resources :events, only: [:new, :create]
  end
  resource :session, only: [:new, :create, :destroy]
  resources :events, except: [:new, :create]
end
