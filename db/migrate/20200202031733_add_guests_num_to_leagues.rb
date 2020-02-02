class AddGuestsNumToLeagues < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :guests_num, :integer, null: false, default: 0
  end
end
