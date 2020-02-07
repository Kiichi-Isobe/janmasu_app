class Chip < ApplicationRecord
  belongs_to :league
  belongs_to :user, optional: true
  has_many :chip_results, dependent: :destroy
  accepts_nested_attributes_for :chip_results, allow_destroy: true

  validate :number_equal_to_0

  # leagueに参加するuser,guestに従ってchip_resultsを作成する
  def set_users_and_guests
    set_users
    set_guests
  end

  # chip_rateにしたがってscoreを計算する
  def add_score
    chip_results.each do |chip_result|
      score = chip_result.number * league.chip_rate / 1000
      chip_result.update_attributes(score: score,
                                    rate_score: score * league.rate)
    end
  end

  private

  # leagueに参加するuserに従ってgame_resultsを作成する
  def set_users
    league.users.order(:id).each do |user|
      chip_results.build(user_id: user.id)
    end
  end

  # leagueに参加するguestに従ってgame_resultsを作成する
  def set_guests
    league.guests_num.times do |i|
      chip_results.build(guest_num: i + 1)
    end
  end

  # numberの合計が0にならない場合エラーを返す
  def number_equal_to_0
    return if number_sum.zero?

    errors.add :base, '合計が0になるように入力してください'
  end

  # numberの合計を返す
  def number_sum
    res = 0
    chip_results.each do |chip_result|
      res += chip_result.number unless chip_result.number.nil?
    end
    res
  end
end
