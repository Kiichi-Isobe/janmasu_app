class RulesController < ApplicationController
  before_action :require_login

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

  private

  def rule_params
    params.require(:rule).permit(:name, :haikyu_genten, :genten, :uma,
                                 :tobi, :fraction_process, :tobi_prize, :rate)
  end
end
