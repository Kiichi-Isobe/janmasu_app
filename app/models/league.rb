class League < ApplicationRecord
  belongs_to :rule
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
end
