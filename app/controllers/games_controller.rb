class GamesController < ApplicationController
  before_action :require_login
  before_action :current_league

  def new
    @game = @league.games.build
    @game.set_users_and_guests
  end

  private

  def current_league
    @league = current_user.leagues.find_by(id: params[:league_id])
    redirect_to root_url unless @league
  end
end
