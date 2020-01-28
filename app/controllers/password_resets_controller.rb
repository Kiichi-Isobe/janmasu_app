class PasswordResetsController < ApplicationController
  before_action :require_correct_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]
  def new; end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, notice: 'ご登録のメールアドレスにメールを送信しました'
    else
      flash[:danger] = 'メールアドレスが正しくありません'
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, :blank)
      render :edit
    elsif @user.update(user_params)
      session[:user_id] = @user.id
      redirect_to mypage_url, notice: 'パスワードが再設定されました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def require_correct_user
    @user = User.find_by(email: params[:email])
    return if @user&.authenticated?(:reset, params[:id])

    flash[:danger]
    redirect_to root_url
  end

  def check_expiration
    return unless @user.reset_sent_at < 2.hours.ago

    flash[:danger] = 'リンクの有効期限が切れています'
    redirect_to new_password_reset_url
  end
end
