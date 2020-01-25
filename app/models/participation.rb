class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :league
end
