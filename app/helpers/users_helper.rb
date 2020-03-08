module UsersHelper
  # ユーザーの順位を計算して返す
  def ranking(user, cmd, reverse = true)
    a = current_user.friends.includes(:game_results, :chip_results).map { |cur| cur.send(cmd) }
    a.push(current_user.send(cmd))
    if reverse
      a.sort.reverse.bsearch_index { |x| x <= user.send(cmd) } + 1
    else
      a.sort.bsearch_index { |x| x >= user.send(cmd) } + 1
    end
  end

  # ユーザーの順位の統計を表示形式を整えて返す
  def show_total_rank(user)
    "#{user.first_num}-#{user.second_num}-#{user.third_num}-#{user.fourth_num}"
  end

  # 平均順位2.5のプレイヤーが与えられた平均順位をとる確率を返す
  def cdf(user)
    norm = Rubystats::NormalDistribution.new(2.5, (1.25 / user.game_results.size)**0.5)
    cdf = norm.cdf(user.game_results.average(:rank))
    (cdf * 100).round(1)
  end
end
