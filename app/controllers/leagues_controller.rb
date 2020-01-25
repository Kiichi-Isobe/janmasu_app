class LeaguesController < ApplicationController
  before_action :require_login

  def index
    @leagues = current_user.leagues
  end

  def new
    @league = League.new
    @rules = current_user.rules.to_a.map { |rule| [rule.name, rule.id] }
    @followings = current_user.followings
  end

  def create
    @league = current_user.leagues.build(league_params)

    if @league.save
      redirect_to leagues_url, notice: '新規対局を作成しました'
    else
      render :new
    end
  end

  private

  def league_params
    params[:league][:user_ids].push(current_user.id.to_s)
    params.require(:league).permit(:rule_id, user_ids: [])
  end
end
