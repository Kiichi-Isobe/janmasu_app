class AddChipRateToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :chip_rate, :integer, default: 2000, null: false
  end
end
