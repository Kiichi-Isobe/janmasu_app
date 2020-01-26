class Game < ApplicationRecord
  belongs_to :league
  has_many :game_results, dependent: :destroy
  accepts_nested_attributes_for :game_results, allow_destroy: true

  validate :score_num_equal_to_haikyu_genten
  validate :correct_rank
  validate :has_4_game_results
  validate :not_has_tobi
  validate :correct_tobi

  def set_users_and_guests
    league.users.each do |user|
      game_results.build(user_id: user.id)
    end
    return unless league.need_guests?

    league.guests_num.times do |i|
      game_results.build(guest_num: i + 1)
    end
  end

  def save_and_calc
    game_results.each do |game_result|
      game_result.mark_for_destruction if game_result.score.blank?
    end
    save
    add_rank
    add_calc_score
  end

  private

  def score_num_equal_to_haikyu_genten
    return if score_sum == 4 * Rule.haikyu_gentens[league.rule.haikyu_genten]

    errors.add :base, '点数の合計が正しくありません'
  end

  def score_sum
    res = 0
    game_results.each do |game_result|
      res += game_result.score unless game_result.score.blank?
    end
    res
  end

  def correct_rank
    return if game_results.first.rank.nil?

    rank = Set.new
    game_results.each do |game_result|
      rank.add(game_result.rank)
    end
    return if rank.size == game_results.size

    errors.add :game_results_rank, 'が正しくありません'
  end

  def has_4_game_results
    cnt = 0
    game_results.each do |game_result|
      cnt += 1 unless game_result.score.blank?
    end
    return if cnt == 4

    errors.add :base, '4人分の点数を入力してください'
  end

  def not_has_tobi
    return if league.rule.tobi == 'tobi_yes'

    error_flag = 0
    game_results.each do |game_result|
      error_flag = 1 if game_result.tobi || game_result.tobasi
    end
    errors.add :game_results_tobi, 'なしのルールに設定されています' if error_flag == 1
  end

  def correct_tobi
    return if league.rule.tobi == 'tobi_no'

    error_flag = 0
    tobi_cnt = 0
    tobasi_cnt = 0
    game_results.each do |game_result|
      break if game_result.score.blank?

      error_flag = 1 if game_result.tobi && game_result.tobasi
      tobi_cnt += 1 if game_result.tobi
      tobasi_cnt += 1 if game_result.tobasi
    end
    error_flag = 1 if tobi_cnt != 0 && tobasi_cnt != 1
    error_flag = 1 if tobi_cnt.zero? && tobasi_cnt != 0

    errors.add :game_results_tobi, 'の設定が正しくありません' if error_flag == 1
  end

  def add_rank
    rank = 4
    game_results.order(:score).each do |game_result|
      game_result.update_attribute(:rank, rank)
      rank -= 1
    end
  end

  def add_calc_score
    sum_score = 0
    game_results.order(:score).each do |game_result|
      if game_result.rank == 1
        calc_score = -1 * sum_score
      else
        calc_score = round_score(game_result.score)
        calc_score -= Rule.gentens[league.rule.genten]
        calc_score += calc_uma(game_result.rank) + calc_tobi_tobasi(game_result)
        sum_score  += calc_score
      end
      game_result.update_attributes(calc_score: calc_score)
      game_result.update_attributes(
        rate_score: (calc_score / 1000.to_f * league.rule.rate).round
      )
    end
  end

  def round_score(score)
    case league.rule.fraction_process
    when 'fraction_process_no'
      score
    when 'fraction_process_round_down'
      score.truncate(-3)
    when 'fraction_process_round_up'
      score.ceil(-3)
    when 'fraction_process_decide_by_genten'
      if score < Rule.gentens[current_rule.genten]
        score.ceil(-3)
      else
        score.truncate(-3)
      end
    when 'fraction_process_round4'
      score.round(-3)
    when 'fraction_process_round5'
      score.round(-3, half: :down)
    end
  end

  def calc_uma(rank)
    if league.rule.uma == 'uma_no'
      0
    else
      uma_score(rank)
    end
  end

  def uma_score(rank)
    case rank
    when 4
      league.rule.uma.split('_')[2].to_i * -1000
    when 3
      league.rule.uma.split('_')[1].to_i * -1000
    else
      league.rule.uma.split('_')[1].to_i * 1000
    end
  end

  def calc_tobi_tobasi(game_result)
    tobi(game_result) + tobasi(game_result)
  end

  def tobi(game_result)
    if game_result.tobi
      -1 * league.rule.tobi_prize
    else
      0
    end
  end

  def tobasi(game_result)
    if game_result.tobasi
      game_results.where(tobi: true).size * league.rule.tobi_prize
    else
      0
    end
  end
end
