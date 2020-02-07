class CreateChips < ActiveRecord::Migration[5.2]
  def change
    create_table :chips do |t|
      t.references :league, foreign_key: true

      t.timestamps
    end
  end
end
