class AddRuleColumnsToLeagues < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :haikyu_genten, :integer
    add_column :leagues, :genten, :integer
    add_column :leagues, :uma, :integer
    add_column :leagues, :tobi, :integer
    add_column :leagues, :fraction_process, :integer
    add_column :leagues, :tobi_prize, :integer
    add_column :leagues, :rate, :integer
  end
end
