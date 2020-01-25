class Participation < ApplicationRecord
  before_destroy :destroy_last_participation_with_league

  belongs_to :user
  belongs_to :league

  private

  def destroy_last_participation_with_league
    league.destroy if league.participations.count == 1
  end
end
