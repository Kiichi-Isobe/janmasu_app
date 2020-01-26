class RemoveRuleFromLeagues < ActiveRecord::Migration[5.2]
  def change
    remove_reference :leagues, :rule, foreign_key: true
  end
end
