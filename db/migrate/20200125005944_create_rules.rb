class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true
      t.integer :haikyu_genten, null: false
      t.integer :genten, null: false
      t.integer :uma, null: false
      t.integer :tobi, null: false
      t.integer :fraction_process, null: false
      t.integer :tobi_prize, null: false
      t.integer :rate, null: false
      t.timestamps
    end
  end
end
