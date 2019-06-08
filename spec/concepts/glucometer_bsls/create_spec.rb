require 'rails_helper'
require 'spec_helper'

RSpec.describe GlucometerBsls::Operation::Create  do
  let(:mmol) { rand(4.2...8.9).to_s }
  let(:email) { Faker::Internet.email }
  let!(:user) { create(:user, email: email) }
  let(:date) { '2007-12-12 23:59' }
  let(:params) do
    { sugar_level: { email: email, mmol: mmol, date: date } }
  end
  subject(:result) { described_class.call(params: params) }
  
  describe 'Success' do
    it 'creates operation' do
      expect{result}.to change(GlucometerBsl, :count).by(1)
      expect(result).to be_success
      expect(result[:model]).to be_instance_of(GlucometerBsl)
    end
  end

  describe 'Failure' do
    let(:date) { '' }
    let(:params) do
      { sugar_level: { email: email, mmol: mmol, date: date } }
    end

    it 'doesn`t create operation' do
      expect{ result }.to_not change(GlucometerBsl, :count)
      expect(result).to be_failure
    end
  end
end
