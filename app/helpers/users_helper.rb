module UsersHelper
  # ユーザーの順位の統計を表示形式を整えて返す
  def show_total_rank(user)
    rank = user.game_results.group('game_results.rank').size
    (1..4).each do |i|
      rank[i] = 0 if rank[i].nil?
    end
    "#{rank[1]}-#{rank[2]}-#{rank[3]}-#{rank[4]}"
  end
end
