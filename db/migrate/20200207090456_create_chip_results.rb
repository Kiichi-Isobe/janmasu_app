class CreateChipResults < ActiveRecord::Migration[5.2]
  def change
    create_table :chip_results do |t|
      t.references :user, foreign_key: true
      t.references :chip, foreign_key: true
      t.integer :guest_num
      t.integer :number, null: false

      t.timestamps
    end
  end
end
