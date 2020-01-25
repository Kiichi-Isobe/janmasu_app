class RulesController < ApplicationController
  before_action :require_login

  def index
    @rules = current_user.rules
  end

  def new
    @rule = current_user.rules.build(haikyu_genten: :haikyu_genten25000,
                                     genten: :genten30000,
                                     uma: :uma_10_20,
                                     tobi: :tobi_yes,
                                     fraction_process: :fraction_process_round5,
                                     tobi_prize: 10_000,
                                     rate: 50)
  end

  def create
    @rule = current_user.rules.build(rule_params)
    if @rule.save
      redirect_to rules_path, notice: '新規ルールを作成しました'
    else
      render :new
    end
  end

  def edit
    @rule = current_user.rules.find(params[:id])
  end

  def update
    @rule = current_user.rules.find(params[:id])
    if @rule.update(rule_params)
      redirect_to rules_path, notice: "ルール「#{@rule.name}」を編集しました"
    else
      render :edit
    end
  end

  def destroy
    rule = current_user.rules.find(params[:id])
    rule.destroy
    redirect_to rules_path, notice: "ルール「#{rule.name}」を削除しました"
  end

  private

  def rule_params
    params.require(:rule).permit(:name, :haikyu_genten, :genten, :uma,
                                 :tobi, :fraction_process, :tobi_prize, :rate)
  end
end
