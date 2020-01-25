Rails.application.routes.draw do
  root to: 'static_pages#home'

  namespace :admin do
    resources :users
  end

  controller :users do
    resources :users, only: %i[show new create] do
      member do
        get :friend
      end

      collection do
        get :search
      end
    end
  end

  controller :sessions do
    get '/login', action: :new
    post '/login', action: :create
    get '/logout', action: :destroy
  end

  controller :relationships do
    resources :relationships, only: %i[create destroy]
  end

  controller :rules do
    resources :rules
  end
end
