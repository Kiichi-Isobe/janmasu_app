module GamesHelper
  def round_calc_score(fraction_process, calc_score)
    return if calc_score.nil?

    if fraction_process == 'fraction_process_no'
      (calc_score / 1000.to_f).round(1)
    else
      (calc_score / 1000.to_f).round
    end
  end

  def sum_user_results(league, user_id)
    round_calc_score(league.fraction_process,
                     sum_user_score(league, user_id))
  end

  def sum_guest_results(league, guest_num)
    round_calc_score(league.fraction_process,
                     sum_guest_score(league, guest_num))
  end

  def rate_user_results(league, user_id)
    (sum_user_results(league, user_id) * league.rate).round
  end

  def rate_guest_results(league, guest_num)
    (sum_guest_results(league, guest_num) * league.rate).round
  end

  private

  def sum_user_score(league, user_id)
    league.game_results.where(user_id: user_id).sum(:calc_score)
  end

  def sum_guest_score(league, guest_num)
    league.game_results.where(guest_num: guest_num).sum(:calc_score)
  end
end
