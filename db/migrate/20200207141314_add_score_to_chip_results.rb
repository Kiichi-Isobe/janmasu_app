class AddScoreToChipResults < ActiveRecord::Migration[5.2]
  def change
    add_column :chip_results, :score, :integer
  end
end
