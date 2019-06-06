FactoryBot.define do
  factory :exercise do
    status { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    duration { '1.0' }
    begining { '12:00' }
    ending { '13:00' }
  end
end