require 'rails_helper'
require 'spec_helper'

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

  describe 'Success' do
    it 'creates operation' do
      expect(result).to be_success
      expect(result[:model]).to be_instance_of(Exercise)
      expect(result[:day]).to eq(day)
      expect(result[:month]).to eq(month)
      expect(result[:year]).to eq(year)
      expect{ described_class.call(params: params) }.to change(Exercise, :count).by(1)
      expect(result[:duration]).to eq(1.0)
   end
  end

  describe 'Failure' do
    let(:params) do
      {
        exercise: {
          status: 'hard',
          description: 'jumping hard hard',
          begining: '12:00',
          ending: '13:00'
        },
        day_id: 'wrong',
        year_id: year.id.to_s,
        month_id: month.id.to_s
      }
    end

    it 'doesn`t create operation' do
      expect(result).to be_failure
      %w[day month year duration model].each do |attr|
        expect(result[attr]).to be_nil
      end
      
      expect{ described_class.call(params: params) }.to_not change(Exercise, :count)
    end
  end
end
