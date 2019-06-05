class Exercise::Contract::Create < Reform::Form
  property :status
  property :begining
  property :ending
  property :description
  property :day_id
  property :duration
  # validates :begining, presence: true, timeliness: { type: :datetime }
  # validates :ending, presence: true, timeliness: { type: :datetime }
  # validates :status, length: {minimum: 4, maximum: 50}, presence: true
  # validates :description, length: {minimum: 10, maximum: 2000}, presence: true
  validation do
    required(:description).filled(:str?, gteq?: 10, lteq?: 2000)
  end
end
