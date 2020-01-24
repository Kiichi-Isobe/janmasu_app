Rails.application.routes.draw do
  root to: 'static_pages#home'

  namespace :admin do
    resources :users
  end

  controller :users do
    resources :users, only: %i[new create]
  end

  controller :sessions do
    get '/login', action: :new
    post '/login', action: :create
    get '/logout', action: :destroy
  end
end
