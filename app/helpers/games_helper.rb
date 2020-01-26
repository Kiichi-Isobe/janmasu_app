module GamesHelper
  def round_calc_score(fraction_process, calc_score)
    return if calc_score.nil?

    if fraction_process == 'fraction_process_no'
      (calc_score / 1000.to_f).round(1)
    else
      (calc_score / 1000.to_f).round
    end
  end
end
