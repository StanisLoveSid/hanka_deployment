FactoryBot.define do
  factory :glucometer_bsl do
    email { Faker::Internet.email }
    mmol { rand(4.2...8.9) }
    date { '2007-12-12 23:59' }
  end
end
