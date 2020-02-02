class Participation < ApplicationRecord
  before_destroy :destroy_last_participation_with_league

  belongs_to :user
  belongs_to :league

  private

  # leagueに参加する最後のユーザーが削除されるとき、同時にleagueも削除する
  def destroy_last_participation_with_league
    league.destroy if league.participations.count == 1
  end
end
