require 'rspec'
require_relative '../lib/picker'
require_relative '../lib/picker/safe'

RSpec.describe 'Picker' do
  describe '#call' do
    subject { Picker }
    let(:result) { subject.call }

    it 'call is success' do
      expect(result).not_to be_nil
    end
  end
end
