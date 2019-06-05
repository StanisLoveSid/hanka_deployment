require 'rails_helper'
require 'spec_helper'
require_relative '../../../../app/concepts/exercise/operation/create'

RSpec.describe Exercise::Create  do
  it 'prohibits empty params' do
    user = User.create!(email: 'sd32a@sda.sda', password: '123456')
    year = Year.create!(year_number: 1900, user_id: user.id)
    month = Month.create!(month_name: 'October', year_id: year.id, user_id: user.id)
    day = Day.create!(day_number: 21, month_id: month.id, user_id: user.id)
    result = Exercise::Create.(params: {utf8: '✓', exercise: 
                                         {status: "hard", day_id: day.id, 
                                          description: "jumping high to stars", 
                                          begining: "12:00", ending: "13:59"}, commit: "submit",
                                          year_id: year.id, month_id: month.id, day_id: day.id})
    expect(result).to be_failure
  end
end
