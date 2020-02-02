class GamesController < ApplicationController
  before_action :require_login
  before_action :require_correct_user,
                only: %i[edit update destroy rank_edit rank_update]
  before_action :current_league, only: %i[new create]

  def new
    @game = @league.games.build
    @game.set_users_and_guests
  end

  def create
    @game = @league.games.build(game_params)
    if @game.valid?
      @game.save_and_calc
      flash[:notice] = '新規ゲームを作成しました'
      redirect_to(@game.tie_score? ? rank_game_url(@game) : @league)
    else
      render :new
    end
  end

  def edit; end

  def update
    @game.assign_attributes(update_game_params)
    if @game.valid?
      @game.save_and_calc
      flash[:notice] = 'ゲームを編集しました'
      redirect_to(@game.tie_score? ? rank_game_url(@game) : @game.league)
    else
      render :edit
    end
  end

  def destroy
    @game.destroy
    redirect_to @game.league, notice: 'ゲームを削除しました'
  end

  def rank_edit; end

  def rank_update
    if @game.update(update_game_params)
      @game.add_calc_score
      redirect_to @game.league, notice: '順位を編集しました'
    else
      render :rank_edit
    end
  end

  private

  # paramsのleague_idからlegueを見つける
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

  def update_game_params
    params.require(:game).permit(
      game_results_attributes: %i[score tobi tobasi rank id]
    )
  end

  # gameに現在のユーザーが参加していなかったらリダイレクトする
  def require_correct_user
    @game = Game.find(params[:id])
    return if @game.league.users.include?(current_user)

    redirect_to root_url
  end
end
