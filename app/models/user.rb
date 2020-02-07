class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token
  has_secure_password

  before_save :downcase_email
  before_destroy :create_league_copy

  has_many :following_relationships, foreign_key: 'follower_id',
                                     class_name: 'Relationship',
                                     dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :followed_relationships, foreign_key: 'following_id',
                                    class_name: 'Relationship',
                                    dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :leagues, through: :participations
  has_many :game_results, dependent: :destroy
  has_many :chip_results, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  VALID_NAME_REGEX = /\A[0-9a-z_A-Z]*\z/.freeze
  validates :name, format: { with: VALID_NAME_REGEX,
                             message: 'は半角英数字で入力してください' }

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
    following_relationships.find_by(following_id: other_user.id)&.destroy
  end

  # フォローしていたらtrueを返す
  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  # フォローされていたらtrueを返す
  def followed?(other_user)
    followed_relationships.find_by(follower_id: other_user.id)
  end

  # 友達(相互フォロー)であればtrueを返す
  def friend?(other_user)
    following?(other_user) && followed?(other_user)
  end

  # 友達を取得する
  def friends
    following_ids = "SELECT following_id FROM relationships
                     WHERE follower_id = :user_id"
    followed_ids = "SELECT follower_id FROM relationships
                     WHERE following_id = :user_id"
    User.where("id IN (#{following_ids}) AND id IN (#{followed_ids})",
               user_id: id)
  end

  # 友達申請をおくってきたユーザーを取得する
  def friend_request
    following_ids = "SELECT following_id FROM relationships
                     WHERE follower_id = :user_id"
    followed_ids = "SELECT follower_id FROM relationships
                     WHERE following_id = :user_id"
    User.where("id NOT IN (#{following_ids}) AND id IN (#{followed_ids})",
               user_id: id)
  end

  # 渡された文字列を暗号化する
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # 新しいtoken用の文字列を作成する
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # remember_tokenを作成して保存する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # tokenが認証されたときtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # 保存されたremember_tokenを削除する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # reset_tokenを作成して保存する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定用のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # ユーザーと友達の対局記録を取得する
  def feed
    following_ids = "SELECT following_id FROM relationships
                     WHERE follower_id = :user_id"
    league_ids = "SELECT DISTINCT league_id FROM participations
                  WHERE user_id IN (#{following_ids})
                  OR user_id = :user_id"
    League.where("id IN (#{league_ids})", user_id: id)
  end

  # 通算得点を計算する
  def total_score
    if game_results.any?
      (game_results.sum(:calc_score) / 1000.to_f).round(1)
    else
      0.0
    end
  end

  # 平均素点を計算する
  def average_score
    if game_results.any?
      game_results.average(:score).round
    else
      0
    end
  end

  # 平均順位を計算する
  def average_rank
    if game_results.any?
      game_results.average(:rank).round(2)
    else
      0.0
    end
  end

  # トップ率を計算する
  def top_percentage
    if game_results.any?
      (game_results.where(rank: 1).size / game_results.size.to_f).round(3)
    else
      0.0
    end
  end

  # 連帯率を計算する
  def rentai_percentage
    if game_results.any?
      (game_results.where(
        '(game_results.rank = ?) OR (game_results.rank = ?)', 1, 2
      ).size / game_results.size.to_f).round(3)
    else
      0.0
    end
  end

  # ラス率を計算する
  def bottom_percentage
    if game_results.any?
      (game_results.where(rank: 4).size / game_results.size.to_f).round(3)
    else
      0.0
    end
  end

  # トビ率を計算する
  def tobi_percentage
    results_with_tobi =
      game_results.joins(:league).where('leagues.tobi' => 'tobi_yes')
    if results_with_tobi.any?
      (game_results.where(
        tobi: true
      ).size / results_with_tobi.size.to_f).round(3)
    else
      0.0
    end
  end

  # 通算chip_numberを計算する
  def total_chip_number
    if chip_results.any?
      chip_results.sum(:number)
    else
      0
    end
  end

  # 通算rate_scoreを計算する
  def total_rate_score
    if game_results.any?
      game_results.sum(:rate_score)
    else
      0
    end
  end

  # 通算chip_rate_scoreを計算する
  def total_chip_rate_score
    if chip_results.any?
      chip_results.sum(:rate_score)
    else
      0
    end
  end

  # ユーザーが参加するleagueが1日以内に作成されているときtrueを返す
  def create_league_within_1day?
    if leagues.any? &&
       leagues.order(created_at: :desc).first.created_at > 1.day.ago
      true
    else
      false
    end
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    email.downcase!
  end

  # 削除されるユーザーの対局をguestに置き換える
  def create_league_copy
    leagues.each do |league|
      break if league.users.size == 1

      create_game_results_copy(league)
      create_chip_results_copy(league)
      league.update_attribute(:guests_num, league.guests_num + 1)
    end
  end

  # game_resultのコピーを作る
  def create_game_results_copy(league)
    league.game_results.where(user_id: id).each do |game_result|
      new_attr = game_result.attributes
      new_attr.delete('id')
      new_attr['user_id'] = nil
      new_attr['guest_num'] = league.guests_num + 1
      GameResult.create!(new_attr)
    end
  end

  # chip_resultのコピーを作る
  def create_chip_results_copy(league)
    league.chip_model.chip_results.where(user_id: id).each do |chip_result|
      new_attr = chip_result.attributes
      new_attr.delete('id')
      new_attr['user_id'] = nil
      new_attr['guest_num'] = league.guests_num + 1
      ChipResult.create!(new_attr)
    end
  end
end
