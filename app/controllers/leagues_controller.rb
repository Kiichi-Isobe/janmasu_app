class LeaguesController < ApplicationController
  before_action :require_login
  before_action :require_rule, only: :new
  before_action :require_correct_user, only: %i[show destroy]

  def index
    @leagues = current_user.leagues
  end

  def show; end

  def new
    @league = League.new
    @rules = current_user.rules
    @followings = current_user.followings
  end

  def create
    @league = current_user.leagues.build(league_params)
    @rules = current_user.rules
    @followings = current_user.followings

    if @league.save
      redirect_to leagues_url, notice: '新規対局を作成しました'
    else
      render :new
    end
  end

  def destroy
    @league.destroy
    redirect_to leagues_url, notice: "対局「#{@league.created_at}」を削除しました"
  end

  private

  def league_params
    params[:league][:user_ids].push(current_user.id.to_s)
    params.require(:league).permit(:rule_id, user_ids: [])
  end

  def require_correct_user
    @league = current_user.leagues.find_by(id: params[:id])
    redirect_to root_url unless @league
  end

  def require_rule
    return unless current_user.rules.empty?

    store_location
    flash[:danger] = 'まずはルールを1つ作成してください'
    redirect_to new_rule_url
  end
end
