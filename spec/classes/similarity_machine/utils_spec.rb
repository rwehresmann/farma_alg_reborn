require 'rails_helper'


describe SimilarityMachine::Utils do
  let(:object) { Object.new.extend(described_class) }

  describe '#compare_and_shift_each' do
    subject do
      trace = []
      object.compare_and_shift_each(array, trace) { |object_1, object_2|
        trace << [object_1, object_2]
      }

      trace
    end

    context "when array size is 0" do
      let(:array) { [] }

      it "doesn't executes the loop" do
        is_expected.to be_empty
      end
    end

    context "when array size is 1" do
      let(:array) { [1] }

      it "doesn't executes the loop" do
        is_expected.to be_empty
      end
    end

    context "when array size is bigger than 1" do
      let(:array) { [1,2,3] }

      it "executes the loop matching each element with all, removing it from the array after" do
        is_expected.to eq [[1,2], [1,3], [2,3]]
      end
    end
  end
end
