class CreateParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :participations do |t|
      t.integer :user_id, null: false
      t.integer :league_id, null: false

      t.timestamps
      t.index :user_id
      t.index :league_id
      t.index %i[user_id league_id], unique: true
    end
  end
end
