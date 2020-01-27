class GameResult < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :game
  belongs_to :league

  validates :score, presence: true, numericality: { only_integer: true }, allow_nil: true
end
