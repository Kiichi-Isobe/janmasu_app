class Game < ApplicationRecord
  belongs_to :league
  has_many :game_results, dependent: :destroy
  accepts_nested_attributes_for :game_results, allow_destroy: true

  validate :score_num_equal_to_haikyu_genten
  validate :score_divisible_by_100
  validate :correct_rank
  validate :has_4_game_results
  validate :not_has_tobi
  validate :correct_tobi

  # leagueに参加するuser,guestに従ってgame_resultsを作成する
  def set_users_and_guests
    set_users
    set_guests
  end

  # 登録内容を保存し、それに従ってrankやcalc_scoreを計算する
  def save_and_calc
    game_results.each do |game_result|
      game_result.mark_for_destruction if game_result.score.blank?
    end
    save
    add_rank
    add_calc_score
    league.update_statistics
  end

  # 同点のユーザーがいた場合trueを返す
  def tie_score?
    score_set = Set.new
    game_results.each do |game_result|
      score_set.add(game_result.score)
    end
    score_set.size != game_results.size
  end

  # rankとscoreに従ってcalc_scoreを求める
  def add_calc_score
    sum_score = 0
    game_results.order(rank: :desc).each do |game_result|
      if game_result.rank == 1
        calc_score = -1 * sum_score
      else
        calc_score = round_score(game_result.score)
        calc_score -= Rule.gentens[league.genten]
        calc_score += calc_uma(game_result.rank) + calc_tobi_tobasi(game_result)
        sum_score  += calc_score
      end
      game_result.update_attributes(calc_score: calc_score)
      game_result.update_attributes(
        rate_score: (calc_score / 1000.to_f * league.rate).round
      )
    end
  end

  private

  # leagueに参加するuserに従ってgame_resultsを作成する
  def set_users
    league.users.order(:id).each do |user|
      game_results.build(user_id: user.id)
    end
  end

  # leagueに参加するguestに従ってgame_resultsを作成する
  def set_guests
    league.guests_num.times do |i|
      game_results.build(guest_num: i + 1)
    end
  end

  # 点数の合計が配給原点と異なるときエラーを返す
  def score_num_equal_to_haikyu_genten
    return if score_sum == 4 * Rule.haikyu_gentens[league.haikyu_genten]

    errors.add :base, '点数の合計が配給原点と等しくなるように入力してください'
  end

  # 点数の合計を返す
  def score_sum
    res = 0
    game_results.each do |game_result|
      res += game_result.score unless game_result.score.nil?
    end
    res
  end

  # 100で割り切れない点数が存在するときエラーを返す
  def score_divisible_by_100
    error_flag = 0
    game_results.each do |game_result|
      break if game_result.score.nil?

      error_flag = 1 if game_result.score % 100 != 0
    end
    errors.add :base, '100点単位で入力してください' if error_flag == 1
  end

  # rankに被りが存在するときエラーを返す
  def correct_rank
    return if game_results.first.rank.nil?

    rank = Set.new
    game_results.each do |game_result|
      rank.add(game_result.rank)
    end
    return if rank.size == game_results.size

    errors.add :base, '順位が正しくありません'
  end

  # 点数がちょうど4人分入力されていないときエラーを返す
  def has_4_game_results
    cnt = 0
    game_results.each do |game_result|
      cnt += 1 unless game_result.score.blank?
    end
    return if cnt == 4

    errors.add :base, '4人分の点数を入力してください'
  end

  # トビなしのルールで、飛びや飛ばしにチェックがついているときエラーを返す
  def not_has_tobi
    return if league.tobi == 'tobi_yes'

    error_flag = 0
    game_results.each do |game_result|
      error_flag = 1 if game_result.tobi || game_result.tobasi
    end
    errors.add :base, 'トビなしのルールに設定されています' if error_flag == 1
  end

  # トビありのルールで、飛びや飛ばしの入力が矛盾しているときエラーを返す
  def correct_tobi
    return if league.tobi == 'tobi_no'

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

    errors.add :base, 'トビの指定が正しくありません' if error_flag == 1
  end

  # 点数にしたがって順位を計算する
  def add_rank
    rank = 4
    game_results.order(:score).each do |game_result|
      game_result.update_attribute(:rank, rank)
      rank -= 1
    end
  end

  # 端点処理の設定にしたがって計算する
  def round_score(score)
    case league.fraction_process
    when 'fraction_process_no'
      score
    when 'fraction_process_round_down'
      score.truncate(-3)
    when 'fraction_process_round_up'
      score.ceil(-3)
    when 'fraction_process_decide_by_genten'
      if score < Rule.gentens[league.genten]
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

  # ウマの計算をする
  def calc_uma(rank)
    if league.uma == 'uma_no'
      0
    else
      uma_score(rank)
    end
  end

  # 順位にしたがってウマの点数を返す
  def uma_score(rank)
    case rank
    when 4
      league.uma.split('_')[2].to_i * -1000
    when 3
      league.uma.split('_')[1].to_i * -1000
    else
      league.uma.split('_')[1].to_i * 1000
    end
  end

  # 飛びと飛ばしの計算をする
  def calc_tobi_tobasi(game_result)
    tobi(game_result) + tobasi(game_result)
  end

  # 飛びの点数を返す
  def tobi(game_result)
    if game_result.tobi
      -1 * league.tobi_prize
    else
      0
    end
  end

  # 飛んだ人数にしたがって飛ばしの点数を返す
  def tobasi(game_result)
    if game_result.tobasi
      game_results.where(tobi: true).size * league.tobi_prize
    else
      0
    end
  end
end
