require 'rails_helper'
require 'spec_helper'
#require_relative '../../../../app/concepts/exercise/operation/create'

RSpec.describe Exercises::Operation::Create  do
  let(:user) { create(:user) }
  let(:year) { create(:year, user: user) }
  let(:month) { create(:month, year: year, user: user) }
  let(:day) { create(:day, month: month, user: user) }
  let(:attrs_for_exercise) { attributes_for(:exercise) }
  subject(:result) { described_class.call(params: params) }
  let(:params) do
    {
      exercise: {
        status: 'hard',
        description: 'jumping hard hard',
        begining: '12:00',
        ending: '13:00'
      },
      day_id: day.id,
      year_id: year.id.to_s,
      month_id: month.id.to_s
    }
  end

  it 'creates operation' do
    expect(result).to be_success
  end
end


# {"utf8"=>"✓",
#   "exercise"=>{
#     "status"=>"hard",
#     "day_id"=>"1",
#     "description"=>"jumping hard hard",
#     "begining"=>"12:00",
#     "ending"=>"13:00"
#     },
#     "commit"=>"submit",
#     "year_id"=>"1",
#     "month_id"=>"1",
#     "day_id"=>"1"
#   }
