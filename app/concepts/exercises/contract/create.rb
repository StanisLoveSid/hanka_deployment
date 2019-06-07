module Exercises::Contract
  class Create < Reform::Form
    property :status
    property :begining
    property :ending
    property :description
    property :day_id

    validation :default do
      required(:day_id).filled(:int?)
      required(:begining).filled(:date_time?)
      required(:ending).filled(:date_time?)
      required(:status).filled(:str?, min_size?: 4, max_size?: 50)
      required(:description).filled(:str?, min_size?: 10, max_size?: 2000)
    end
  end
end
