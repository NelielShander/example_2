require 'rspec'
require 'dry-struct'
require 'dry-monads'
require 'sorbet-runtime'

require_relative '../../lib/types'
require_relative '../../lib/picker/safe'

RSpec.describe 'Picker::Safe' do
  describe '#pick_combination' do
    subject {
      Picker::Safe.new(
        handles_number:,
        initial_state:,
        target_state:,
        restricted_combinations:
      )
    }
    let(:handles_number) { 2 }
    let(:initial_state) { [0, 0] }
    let(:target_state) { [2, 2] }
    let(:result) { subject.pick_combination }

    describe 'with no restrictions' do
      let(:restricted_combinations) { [] }
      let(:expected_result) { [[0, 0], [0, 1], [0, 2], [1, 2], [2, 2]] }

      it 'be truthy' do
        expect(result.success?).to be_truthy
      end

      it 'has expected combinations' do
        expect(result.success).to eql(expected_result)
      end
    end

    describe 'with restricted turns' do
      let(:restricted_combinations) { [[0, 1], [1, 2]] }
      let(:expected_result) { [[0, 0], [1, 0], [1, 1], [2, 1], [2, 2]] }

      it 'be truthy' do
        expect(result.success?).to be_truthy
      end

      it 'has expected combinations' do
        expect(result.success).to eql(expected_result)
      end
    end

    describe 'failure' do
      describe 'with restricted initial' do
        let(:restricted_combinations) { [[0, 0]] }

        it 'be falsey' do
          expect(result.success?).to be_falsey
        end

        it 'has failure message' do
          expect(result.failure).to eql('Изначальная комбинация есть в запрещенных.')
        end
      end

      describe 'with restricted target' do
        let(:restricted_combinations) { [[2, 2]] }

        it 'be falsey' do
          expect(result.success?).to be_falsey
        end

        it 'has failure message' do
          expect(result.failure).to eql('Целевая комбинация есть в запрещенных.')
        end
      end

      describe 'with no path' do
        let(:handles_number) { 1 }
        let(:initial_state) { [0] }
        let(:target_state) { [2] }
        let(:restricted_combinations) { [[1], [5]] }

        it 'be falsey' do
          expect(result.success?).to be_falsey
        end

        it 'has message' do
          expect(result.failure).to eql('Невозможно подобрать комбинацию.')
        end
      end
    end
  end
end
