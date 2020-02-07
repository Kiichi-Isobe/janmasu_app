class ChipsController < ApplicationController
  before_action :require_login
  before_action :require_correct_user, only: %i[edit update]
  before_action :current_league, only: %i[new create]

  def new
    @chip = @league.build_chip_model
    @chip.set_users_and_guests
  end

  def create
    @chip = @league.build_chip_model(chip_params)
    if @chip.save
      redirect_to @league, notice: 'チップを記録しました'
    else
      render :new
    end
  end

  private

  # paramsのleague_idからlegueを見つける
  def current_league
    @league = current_user.leagues.find_by(id: params[:league_id])
    redirect_to root_url unless @league
  end

  def chip_params
    params.require(:chip).permit(
      chip_results_attributes: %i[
        user_id guest_num number
      ]
    )
  end

  # chipに現在のユーザーが参加していなかったらリダイレクトする
  def require_correct_user
    @chip = Chip.find(params[:id])
    return if @chip.league.users.include?(current_user)

    redirect_to root_url
  end
end
