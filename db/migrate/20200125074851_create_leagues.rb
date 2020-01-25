class CreateLeagues < ActiveRecord::Migration[5.2]
  def change
    create_table :leagues do |t|
      t.references :user, foreign_key: true
      t.references :rule, foreign_key: true

      t.timestamps
    end
  end
end
