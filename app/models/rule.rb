class Rule < ApplicationRecord
  belongs_to :user

  enum haikyu_genten: { haikyu_genten20000: 20_000, haikyu_genten25000: 25_000,
                        haikyu_genten30000: 30_000, haikyu_genten35000: 35_000 }
  enum genten: { genten20000: 20_000, genten25000: 25_000,
                 genten30000: 30_000, genten40000: 40_000 }
  enum uma: { uma_no: 0, uma5_10: 1, uma_10_20: 2, uma_10_30: 3, uma_20_30: 4 }
  enum tobi: { tobi_no: 0, tobi_yes: 1 }
  enum fraction_process: { fraction_process_no: 0,
                           fraction_process_round_down: 1,
                           fraction_process_round_up: 2,
                           fraction_process_decide_by_genten: 3,
                           fraction_process_round4: 4,
                           fraction_process_round5: 5 }

  validates :name, presence: true
  validates :haikyu_genten, presence: true
  validates :genten, presence: true
  validates :uma, presence: true
  validates :tobi, presence: true
  validates :fraction_process, presence: true
  validates :tobi_prize, presence: true, numericality: { only_integer: true }
  validates :rate, presence: true, numericality: { only_integer: true }
end
