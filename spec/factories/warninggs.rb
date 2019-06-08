FactoryBot.define do
  factory :warningg do
    reason { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    begining { '12:00' }
    ending { '13:00' }
  end
end
