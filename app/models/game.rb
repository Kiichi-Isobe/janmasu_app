class Game < ApplicationRecord
  belongs_to :league
  has_many :game_results, dependent: :destroy
  accepts_nested_attributes_for :game_results, allow_destroy: true

  def set_users_and_guests
    league.users.each do |user|
      game_results.build(user_id: user.id)
    end
    return unless league.need_guests?

    league.guests_num.times do |i|
      game_results.build(guest_num: i + 1)
    end
  end
end
