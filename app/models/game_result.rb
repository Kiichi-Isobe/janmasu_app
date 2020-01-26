class GameResult < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :game
  belongs_to :league
end
