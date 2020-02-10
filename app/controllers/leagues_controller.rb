class LeaguesController < ApplicationController
  before_action :require_login
  before_action :require_rule, only: :new
  before_action :require_friend_user, only: :create
  before_action :require_correct_user, only: %i[show destroy]

  def index
    @leagues =
      current_user.leagues.order(created_at: :desc).page(params[:page]).per(5)
  end

  def show; end

  def new
    @league = League.new
    @rules = current_user.rules
    @friends = current_user.friends
  end

  def create
    @league = current_user.leagues.build(league_params)
    @league.assign_rule_params(params[:league][:rule_id])
    @rules = current_user.rules
    @friends = current_user.friends

    if @league.save
      if @league.need_guests?
        @league.update_attribute(:guests_num, @league.need_guests_num)
      end
      redirect_to @league, notice: '新規対局を作成しました'
    else
      render :new
    end
  end

  def destroy
    @league.destroy
    redirect_to leagues_url, notice: '対局を削除しました'
  end

  private

  def league_params
    # 現在のユーザーを自動的にleagueに参加させる
    params[:league][:user_ids].push(current_user.id.to_s)

    params.require(:league).permit(user_ids: [])
  end

  # leagueに現在のユーザーが参加していなかったらリダイレクトする
  def require_correct_user
    @league = current_user.leagues.find_by(id: params[:id])
    redirect_to root_url unless @league
  end

  # 現在のユーザーがruleを1つも作成していなかったらリダイレクトする
  def require_rule
    return unless current_user.rules.empty?

    store_location
    flash[:danger] = 'まずはルールを1つ作成してください'
    redirect_to new_rule_url
  end

  # 友達でないユーザーをleagueに参加させようとしたらリダイレクトする
  def require_friend_user
    params[:league][:user_ids].each do |id|
      unless current_user.friends.where(id: id.to_i)
        redirect_to root_url
        return
      end
    end
  end
end
