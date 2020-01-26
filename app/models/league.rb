class League < ApplicationRecord
  belongs_to :rule
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_many :games, dependent: :destroy
  has_many :game_results, dependent: :destroy

  def need_guests?
    users.size < 4
  end

  def guests_num
    if need_guests?
      4 - users.size
    else
      0
    end
  end
end
