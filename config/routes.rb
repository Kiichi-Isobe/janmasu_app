Rails.application.routes.draw do
  root to: 'static_pages#home'

  controller :static_pages do
    get '/usage', action: :usage
  end

  namespace :admin do
    resources :users
    resources :leagues, only: %i[index show]
  end

  controller :users do
    resources :users, except: :index do
      member do
        get :friend
      end

      collection do
        get :search
      end
    end
    get '/mypage', action: :mypage
    get '/friend_request', action: :friend_request
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

  controller :relationships do
    post 'follow', action: :create
    delete 'unfollow', action: :destroy
  end

  resources :rules, except: :show
  resources :leagues
  resources :password_resets
  resources :chips, only: %i[new create]
end
