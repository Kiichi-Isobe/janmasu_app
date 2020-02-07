class AddChipToLeagues < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :chip, :integer, null: false
  end
end
