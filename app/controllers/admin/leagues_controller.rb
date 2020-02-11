class Admin::LeaguesController < ApplicationController
  before_action :require_admin

  def index
    @leagues = League.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @league = League.find(params[:id])
  end

  private

  def require_admin
    return if current_user&.admin?

    redirect_to root_url
    flash[:danger] = '権限がありません'
  end
end
