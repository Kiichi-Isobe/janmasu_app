class SessionsController < ApplicationController
  before_action :require_login, only: :destroy

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    if @session.valid?
      session[:user_id] = @session.user.id
      if params[:session][:remember_me] == '1'
        remember(@session.user)
      else
        forget(@session.user)
      end
      flash[:notice] = 'ログインしました'
      redirect_back_or mypage_url
    else
      render :new
    end
  end

  def destroy
    forget(current_user)
    reset_session
    redirect_to root_url, notice: 'ログアウトしました'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
