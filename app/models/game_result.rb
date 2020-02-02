class GameResult < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :game
  belongs_to :league

  validates :score, presence: true, numericality: { only_integer: true }, allow_nil: true

  scope :user_participated, -> { where.not(user_id: nil).order(:user_id) }
  scope :guest_participated, -> { where.not(guest_num: nil).order(:guest_num) }
end
