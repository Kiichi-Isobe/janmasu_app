class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  VALID_NAME_REGEX = /\A[0-9a-zA-Z]*\z/.freeze
  validates :name, format: { with: VALID_NAME_REGEX, message: 'は半角英数字で入力してください' }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false }
  validates :email, format: { with: VALID_EMAIL_REGEX, message: 'の形式が間違っています' },
                    allow_blank: true

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
