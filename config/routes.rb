Rails.application.routes.draw do
  root to: 'static_pages#home'

  namespace :admin do
    resources :users
  end

  controller :users do
    resources :users, except: %i[index] do
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
end
