class AddChipToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :chip, :integer, default: 0, null: false
  end
end
