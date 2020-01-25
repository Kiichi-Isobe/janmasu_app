class User < ApplicationRecord
  has_secure_password

  before_save :downcase_email

  has_many :following_relationships, foreign_key: 'follower_id',
                                     class_name: 'Relationship',
                                     dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :followed_relationships, foreign_key: 'following_id',
                                    class_name: 'Relationship',
                                    dependent: :destroy
  has_many :rules, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  VALID_NAME_REGEX = /\A[0-9a-zA-Z]*\z/.freeze
  validates :name, format: { with: VALID_NAME_REGEX, message: 'は半角英数字で入力してください' }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false }
  validates :email, format: { with: VALID_EMAIL_REGEX, message: 'の形式が間違っています' },
                    allow_blank: true

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # ユーザーをフォローする
  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしていたらtrueを返す
  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    email.downcase!
  end
end
