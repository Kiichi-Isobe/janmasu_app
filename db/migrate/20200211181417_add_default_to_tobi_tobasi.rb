class AddDefaultToTobiTobasi < ActiveRecord::Migration[5.2]
  def change
    change_column_default :game_results, :tobi, from: nil, to: false
    change_column_default :game_results, :tobasi, from: nil, to: false
  end
end
