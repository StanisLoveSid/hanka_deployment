module Exercises::Contract
  class Create < Reform::Form
    property :status
    property :begining
    property :ending
    property :description
    property :day_id

    # validates :begining, presence: true, timeliness: { type: :datetime }
    # validates :ending, presence: true, timeliness: { type: :datetime }
    # validates :status, length: {minimum: 4, maximum: 50}, presence: true
    # validates :description, length: {minimum: 10, maximum: 2000}, presence: true
    validation :default do
      required(:begining).filled(:date_time?)
      required(:ending).filled(:date_time?)
      required(:status).filled(:str?, min_size?: 4, max_size?: 50)
      required(:description).filled(:str?, min_size?: 10, max_size?: 2000)
    end
  end
end
