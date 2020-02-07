module GamesHelper
  # 端点処理の設定にしたがってスコアの表示形式を整える
  def round_calc_score(fraction_process, calc_score)
    return if calc_score.nil?

    if fraction_process == 'fraction_process_no'
      (calc_score / 1000.to_f).round(1)
    else
      (calc_score / 1000.to_f).round
    end
  end

  # 指定のleague,userの合計スコアを、表示形式を整えて返す
  def sum_user_results(league, user_id)
    res = round_calc_score(league.fraction_process,
                           sum_user_score(league, user_id)) +
          chip_user_results(league, user_id)
    res
  end

  # 指定のleague,guestの合計スコアを、表示形式を整えて返す
  def sum_guest_results(league, guest_num)
    res = round_calc_score(league.fraction_process,
                           sum_guest_score(league, guest_num)) +
          chip_guest_results(league, guest_num)
    res
  end

  # 指定のleague,userの合計収支を、表示形式を整えて返す
  def rate_user_results(league, user_id)
    (sum_user_results(league, user_id) * league.rate).round
  end

  # 指定のleague,guestの合計収支を、表示形式を整えて返す
  def rate_guest_results(league, guest_num)
    (sum_guest_results(league, guest_num) * league.rate).round
  end

  # 指定のleague,userのチップスコアを、表示形式を整えて返す
  def chip_user_results(league, user_id)
    if league.chip_model
      league.chip_model.chip_results.find_by(user_id: user_id).score
    else
      0
    end
  end

  # 指定のleague,guestのチップスコアを、表示形式を整えて返す
  def chip_guest_results(league, guest_num)
    if league.chip_model
      league.chip_model.chip_results.find_by(guest_num: guest_num).score
    else
      0
    end
  end

  private

  # 指定のleague,userの合計スコアを返す
  def sum_user_score(league, user_id)
    league.game_results.where(user_id: user_id).sum(:calc_score)
  end

  # 指定のleague,guestの合計スコアを返す
  def sum_guest_score(league, guest_num)
    league.game_results.where(guest_num: guest_num).sum(:calc_score)
  end
end
