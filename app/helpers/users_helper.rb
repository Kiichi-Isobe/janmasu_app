module UsersHelper
  def total_score_rank(user)
    a = current_user.friends.pluck(:calc_score)
    a.push(current_user.calc_score)
    a.sort.reverse.bsearch_index { |x| x <= user.calc_score } + 1
  end

  def ranking(user, cmd)
    a = current_user.friends.includes(:game_results).map { |user| user.send(cmd) }
    a.push(current_user.send(cmd))
    a.sort.reverse.bsearch_index { |x| x <= user.send(cmd) } + 1
  end

  # ユーザーの順位の統計を表示形式を整えて返す
  def show_total_rank(user)
    rank = user.game_results.group('game_results.rank').size
    (1..4).each do |i|
      rank[i] = 0 if rank[i].nil?
    end
    "#{rank[1]}-#{rank[2]}-#{rank[3]}-#{rank[4]}"
  end
end
