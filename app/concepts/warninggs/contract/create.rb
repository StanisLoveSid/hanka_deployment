module Warninggs::Contract
  class Create < Reform::Form
    property :reason
    property :begining
    property :ending
    property :description
    property :day_id

    validation :default do
      required(:day_id).filled(:int?)
      required(:begining).filled(:date_time?)
      required(:ending).filled(:date_time?)
      required(:reason).filled(:str?, min_size?: 4, max_size?: 50)
      required(:description).filled(:str?, min_size?: 10, max_size?: 2000)
    end
  end
end