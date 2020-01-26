class AddRuleColumnsToLeagues < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :haikyu_genten, :integer, null: false
    add_column :leagues, :genten, :integer, null: false
    add_column :leagues, :uma, :integer, null: false
    add_column :leagues, :tobi, :integer, null: false
    add_column :leagues, :fraction_process, :integer, null: false
    add_column :leagues, :tobi_prize, :integer, null: false
    add_column :leagues, :rate, :integer, null: false
  end
end
