class RemoveUserFromLeagues < ActiveRecord::Migration[5.2]
  def change
    remove_reference :leagues, :user, foreign_key: true
  end
end
