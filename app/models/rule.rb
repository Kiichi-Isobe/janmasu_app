class Rule < ApplicationRecord
  belongs_to :user

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

  validates :name, presence: true, length: { maximum: 20 }
  validates :haikyu_genten, presence: true
  validates :genten, presence: true
  validates :uma, presence: true
  validates :tobi, presence: true
  validates :fraction_process, presence: true
  validates :tobi_prize, presence: true
  validates :tobi_prize, numericality: { only_integer: true }, allow_nil: true
  validates :rate, presence: true
  validates :rate, numericality: { only_integer: true }, allow_nil: true

  validate  :genten_greater_than_haikyu_genten
  validate  :rate_divisible_by_10
  validate  :tobi_prize_divisible_by_100

  # idなどをのぞいたruleの設定を返す
  def rule_attr
    need_attr = attributes
    need_attr.delete('id')
    need_attr.delete('user_id')
    need_attr.delete('name')
    need_attr.delete('created_at')
    need_attr.delete('updated_at')
    need_attr
  end

  private

  # 配給原点が原点よりもおおきいときエラーを返す
  def genten_greater_than_haikyu_genten
    return if Rule.haikyu_gentens[haikyu_genten] <= Rule.gentens[genten]

    errors.add :base, '配給原点は原点以下に設定してください'
  end

  # rateが10で割り切れないときエラーを返す
  def rate_divisible_by_10
    return if rate.nil?

    errors.add :rate, 'は10P単位で入力してください' if rate % 10 != 0
  end

  # tobi_prizeが100で割り切れないときエラーを返す
  def tobi_prize_divisible_by_100
    return if tobi_prize.nil?

    errors.add :tobi_prize, 'は100点単位で入力してください' if tobi_prize % 100 != 0
  end
end
