class RulesController < ApplicationController
  before_action :require_login
  before_action :require_correct_user, only: %i[edit update destroy]

  def index
    @rules = current_user.rules.page(params[:page]).per(20)
  end

  def new
    @rule = current_user.rules.build
  end

  def create
    @rule = current_user.rules.build(rule_params)
    if @rule.save
      flash[:notice] = '新規ルールを作成しました'
      redirect_back_or rules_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @rule.update(rule_params)
      redirect_to rules_path, notice: "ルール「#{@rule.name}」を編集しました"
    else
      render :edit
    end
  end

  def destroy
    @rule.destroy
    redirect_to rules_path, notice: "ルール「#{@rule.name}」を削除しました"
  end

  private

  def rule_params
    params.require(:rule).permit(:name, :haikyu_genten, :genten, :uma,
                                 :tobi, :chip, :fraction_process,
                                 :tobi_prize, :chip_rate, :rate)
  end

  # ruleが現在のユーザーのものでなければリダイレクトする
  def require_correct_user
    @rule = current_user.rules.find_by(id: params[:id])
    redirect_to root_url unless @rule
  end
end
