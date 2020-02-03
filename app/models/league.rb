class League < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_many :games, dependent: :destroy
  has_many :game_results, dependent: :destroy

  validate :user_less_than_17

  scope :most_recent, -> { order(created_at: :desc).first }

  enum haikyu_genten: { haikyu_genten20000: 20_000, haikyu_genten25000: 25_000,
                        haikyu_genten30000: 30_000, haikyu_genten35000: 35_000 }
  enum genten: { genten20000: 20_000, genten25000: 25_000,
                 genten30000: 30_000, genten40000: 40_000 }
  enum uma: { uma_no: 0, uma_5_10: 1, uma_10_20: 2, uma_10_30: 3, uma_20_30: 4 }
  enum tobi: { tobi_no: 0, tobi_yes: 1 }
  enum fraction_process: { fraction_process_no: 0,
                           fraction_process_round_down: 1,
                           fraction_process_round_up: 2,
                           fraction_process_decide_by_genten: 3,
                           fraction_process_round4: 4,
                           fraction_process_round5: 5 }

  # leagueにguestが参加するときtrueを返す
  def need_guests?
    users.size < 4
  end

  # 合計が4人になるように必要なguestの人数を返す
  def need_guests_num
    if need_guests?
      4 - users.size
    else
      0
    end
  end

  # 入力されたルールにしたがってleagueのルールを設定する
  def assign_rule_params(rule_id)
    rule_attr = Rule.find(rule_id).rule_attr
    assign_attributes(rule_attr)
  end

  private

  # leagueに参加するユーザーが17人以上の時エラーを返す
  def user_less_than_17
    return if users.size < 17

    errors.add :base, '1度に対局に参加できるのは最大16人までです'
  end
end
