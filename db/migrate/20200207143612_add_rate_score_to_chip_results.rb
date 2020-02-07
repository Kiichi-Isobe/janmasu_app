class AddRateScoreToChipResults < ActiveRecord::Migration[5.2]
  def change
    add_column :chip_results, :rate_score, :integer
  end
end
