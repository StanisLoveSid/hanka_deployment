require 'rails_helper'
require 'spec_helper'
require_relative '../../../../app/concepts/exercise/contract/create'

RSpec.describe Exercise::Contract::Create do
  subject(:form) { described_class.new(Exercise.new) }

  let(:valid_params) { {exercise: 
                        {status: "hard", day_id: 1, 
                        description: "jumping high to stars", 
                        begining: "12:00", ending: "13:59"}, commit: "submit",
                        year_id: 1, month_id: 1, day_id: 1} }

  describe 'validation' do
    describe 'not valid' do
      it { expect(form.validate(valid_params)).to eq(false) }
    end
  end
end
