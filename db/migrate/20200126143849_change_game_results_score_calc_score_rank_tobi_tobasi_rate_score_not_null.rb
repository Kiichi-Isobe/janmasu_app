class ChangeGameResultsScoreCalcScoreRankTobiTobasiRateScoreNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :game_results, :score, false
    change_column_null :game_results, :tobi, false
    change_column_null :game_results, :tobasi, false
  end
end
