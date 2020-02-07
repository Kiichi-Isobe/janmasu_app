class ChipResult < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :chip

  validates :number, presence: true
  validates :number, numericality: { only_integer: true }, allow_nil: true
end
