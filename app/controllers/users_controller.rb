class UsersController < ApplicationController
  before_action :require_login, only: :search

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_url, notice: '新規ユーザーを作成しました'
    else
      render :new
    end
  end

  def search
    return if params[:name].nil?

    @user = User.find_by(name: params[:name])
    if @user
      redirect_to user_url(@user)
    else
      flash[:danger] = 'ユーザーが見つかりませんでした'
      redirect_to search_users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
