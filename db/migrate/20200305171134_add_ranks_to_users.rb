class AddRanksToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_num, :integer, null: false, default: 0
    add_column :users, :second_num, :integer, null: false, default: 0
    add_column :users, :third_num, :integer, null: false, default: 0
    add_column :users, :fourth_num, :integer, null: false, default: 0
  end
end
