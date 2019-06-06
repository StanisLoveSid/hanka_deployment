require 'rails_helper'
require 'spec_helper'
#require_relative '../../../../app/concepts/exercise/contract/create'

RSpec.describe Exercises::Contract::Create do
  subject(:form) { described_class.new(Exercise.new) }

  let(:user) { create(:user) }
  let(:year) { create(:year, user: user) }
  let(:month) { create(:month, year: year, user: user) }
  let(:day) { create(:day, month: month, user: user) }
  let(:attrs_for_exercise) { attributes_for(:exercise) }
  let(:valid_params) { { params: { exercise: attrs_for_exercise, day_id: day.id } } }

  describe 'validation' do
    describe 'not valid' do
      it { expect(form.validate(valid_params)).to eq(false) }
    end
  end
end
