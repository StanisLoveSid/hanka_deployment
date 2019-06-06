FactoryBot.define do
  factory :day do
    day_number { rand(1..31) }
  end
end