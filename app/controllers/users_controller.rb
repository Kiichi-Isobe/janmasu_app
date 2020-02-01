class UsersController < ApplicationController
  before_action :require_login, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy]
  before_action :redirect_test_user, only: %i[edit update destroy]

  def show
    @user = User.find(params[:id])
    if current_user == @user
      redirect_to mypage_url
      return
    end
    @leagues = @user.leagues.order(created_at: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: '新規ユーザーを作成しました'
    else
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].present? && !@user.authenticate(params[:user][:old_password])
      @user.errors.add :base, '現在のパスワードが間違っています'
      render :edit
      return
    end
    if @user.update(user_params)
      redirect_to mypage_url, notice: "ユーザー「#{@user.name}」を編集しました"
    else
      render :edit
    end
  end

  def destroy
    @user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    reset_session
    @user.destroy
    redirect_to root_url, notice: "ユーザー「#{@user.name}」を削除しました"
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
    @followings = @user.followings.includes(:game_results).page(params[:page])
  end

  def mypage
    @leagues = current_user.feed.order(created_at: :desc).limit(5)
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

  def redirect_test_user
    return unless current_user.test

    flash[:danger] = 'テストユーザーはユーザー設定を変更できません'
    redirect_to mypage_url
  end
end
