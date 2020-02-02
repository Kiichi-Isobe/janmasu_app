class AddDefaultToHaikyuGentenGentenUmaTobiFractionProcessTobiPrizeRate < ActiveRecord::Migration[5.2]
  def change
    change_column_default :rules, :haikyu_genten, from: nil, to: 25_000
    change_column_default :rules, :genten, from: nil, to: 30_000
    change_column_default :rules, :uma, from: nil, to: 2
    change_column_default :rules, :tobi, from: nil, to: 1
    change_column_default :rules, :fraction_process, from: nil, to: 5
    change_column_default :rules, :tobi_prize, from: nil, to: 10_000
    change_column_default :rules, :rate, from: nil, to: 50
  end
end
