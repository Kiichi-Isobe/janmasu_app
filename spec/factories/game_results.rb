FactoryBot.define do
  factory :game_result do
    user { nil }
    game { nil }
    league { nil }
    score { 1 }
    calc_score { 1 }
    rank { 1 }
    tobi { false }
    tobasi { false }
    rate_score { 1 }
  end
end
