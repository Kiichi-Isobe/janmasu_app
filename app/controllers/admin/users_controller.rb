class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(admin_user_params)

    if @user.save
      redirect_to admin_users_url, notice: '新規ユーザーを作成しました'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(admin_user_params)
      redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を編集しました"
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{user.name}」を削除しました"
  end

  private

  def admin_user_params
    params.require(:user).permit(:name, :email, :admin, :test,
                                 :password, :password_confirmation)
  end
end
