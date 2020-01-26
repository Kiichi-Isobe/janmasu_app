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

  controller :games do
    resources :games do
      member do
        get :rank, action: :rank_edit
        patch :rank, action: :rank_update
      end
    end
  end

  resources :relationships, only: %i[create destroy]
  resources :rules, except: :show
  resources :leagues
end
