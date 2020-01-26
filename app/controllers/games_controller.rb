class GamesController < ApplicationController
  before_action :require_login
  before_action :current_league

  def new
    @game = @league.games.build
    @game.set_users_and_guests
  end

  def create
    @game = @league.games.build(game_params)
    if @game.valid?
      @game.save_and_calc
      redirect_to @league, notice: '新規ゲームを作成しました'
    else
      render :new
    end
  end

  private

  def current_league
    @league = current_user.leagues.find_by(id: params[:league_id])
    redirect_to root_url unless @league
  end

  def game_params
    params.require(:game).permit(
      game_results_attributes: %i[
        user_id guest_num league_id score tobi tobasi
      ]
    )
  end
end
