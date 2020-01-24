class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, null: false
      t.integer :following_id, null: false

      t.timestamps
      t.index :follower_id
      t.index :following_id
      t.index %i[follower_id following_id], unique: true
    end
  end
end
