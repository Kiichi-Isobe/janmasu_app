class UsersController < ApplicationController
  before_action :require_login, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update]

  def show
    @user = User.find(params[:id])
    @leagues = @user.leagues.order(created_at: :desc).limit(3)
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

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to mypage_url, notice: "ユーザー「#{@user.name}」を編集しました"
    else
      render :edit
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

  def friend
    @user = User.find(params[:id])
  end

  def mypage
    @leagues = current_user.leagues.order(created_at: :desc).limit(5)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_correct_user
    @user = User.find_by(id: params[:id])
    return if current_user == @user

    redirect_to root_url
  end
end
