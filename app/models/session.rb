class Session
  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email, presence: true
  validates :password, presence: true
  validate :authenticate_user

  def user
    User.find_by(email: email.downcase)
  end

  private

  def authenticate_user
    return if email.blank? || password.blank?

    unless user
      errors.add :base, 'メールアドレスもしくはパスワードが間違っています'
      return
    end
    return if user.authenticate(password)

    errors.add :base, 'メールアドレスもしくはパスワードが間違っています'
  end
end
