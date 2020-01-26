class CreateGameResults < ActiveRecord::Migration[5.2]
  def change
    create_table :game_results do |t|
      t.references :user, foreign_key: true
      t.references :game, foreign_key: true
      t.references :league, foreign_key: true
      t.integer :score
      t.integer :calc_score
      t.integer :rank
      t.boolean :tobi
      t.boolean :tobasi
      t.integer :rate_score
      t.integer :guest_num
      t.timestamps
    end
  end
end
