class SessionsController < ApplicationController
  before_action :require_login, only: :destroy

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    if @session.valid?
      session[:user_id] = @session.user.id
      flash[:notice] = 'ログインしました'
      redirect_back_or root_url
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'ログアウトしました'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
