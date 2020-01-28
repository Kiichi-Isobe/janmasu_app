class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail(
      subject: 'パスワードの再設定',
      to: @user.email
    )
  end
end
