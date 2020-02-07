class AddChipRateToLeagues < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :chip_rate, :integer, null: false
  end
end
