class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  # 現在ログインしているユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  # ログインしていなかったらログインページにリダイレクトする
  def require_login
    return if current_user

    store_location
    flash[:danger] = 'ログインしてください'
    redirect_to login_url
  end

  # リクエストされたURLをセッションに保存する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # セッションに保存されたURLにリダイレクトする
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
