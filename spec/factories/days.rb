FactoryBot.define do
  factory :day do
    day_number { rand(1..31) }
  end

  trait :with_exercises do
    transient do
      exercises_amount { 1 }
    end

    after(:create) do |day, evaluator|
      create_list(:exercise, evaluator.exercises_amount, day: day)
    end
  end

  trait :with_warninggs do
    transient do
      warninggs_amount { 1 }
    end

    after(:create) do |day, evaluator|
      create_list(:warningg, evaluator.warninggs_amount, day: day)
    end
  end
end
