FactoryBot.define do
  factory :month do
    month_name { Date::MONTHNAMES.sample }
  end
end