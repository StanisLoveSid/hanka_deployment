FactoryBot.define do
  factory :year do
    year_number { rand(1..Time.now.year) }
  end
end