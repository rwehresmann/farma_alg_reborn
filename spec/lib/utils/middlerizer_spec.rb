require 'rails_helper'
require 'utils/middlerizer'

describe Middlerizer do
  context "when cannot find the middle object" do
    subject { Middlerizer.new(middle: 10, array: [1,2,3]) }

    it { expect { subject }.to raise_error(ArgumentError) }
  end

  context "without limits specified" do
    let(:array) { [5,4,3,2,1] }

    subject {
      Middlerizer.new(middle: middle, array: array)
    }

    context "when initiaded in a way that upper half will be empty" do
      let(:middle) { array.last }

      it { common_expectations(upper_half: [], middle: middle, lower_half: [5,4,3,2]) }
    end

    context "when initiaded in a way that lower half will be empty" do
      let(:middle) { array.first }

      it { common_expectations(upper_half: [4,3,2,1], middle: middle, lower_half: []) }
    end

    context "when initiaded in a way that neither lower_half and upper_half will be empty" do
      let(:middle) { array.third }

      it { common_expectations(upper_half: [2,1], middle: middle, lower_half: [5,4]) }
    end
  end

  context "with limits specified" do
    let(:array) { [5,4,3,2,1] }

    subject { Middlerizer.new(
        middle: middle,
        array: array,
        limits: { upper: 1, lower: 1 }
      )
    }

    context "when initiaded in a way that upper half will be empty" do
      let(:middle) { array.last }

      it { common_expectations(upper_half: [], middle: middle, lower_half: [2]) }
    end

    context "when initiaded in a way that lower half will be empty" do
      let(:middle) { array.first }

      it { common_expectations(upper_half: [4], middle: middle, lower_half: []) }
    end

    context "when initiaded in a way that neither lower_half and upper_half will be empty" do
      let(:middle) { array.third }

      it { common_expectations(upper_half: [2], middle: middle, lower_half: [4]) }
    end
  end

  describe '#to_hash' do
    let(:middle) { 3 }
    subject {
      Middlerizer.new(middle: middle, array: [5,4,3,2,1]).to_hash
    }

    it "transforms in a hash object" do
      expect(subject[:middle]).to eq(middle)
      expect(subject[:lower_half]).to eq([5,4])
      expect(subject[:upper_half]).to eq([2,1])
    end
  end

  describe '#size' do
    let(:array) { [5,4,3,2,1] }

    subject { Middlerizer.new(middle: 3, array: array).to_array }

    it { expect(subject).to eq(array) }
  end

  describe '#to_array' do


  end

  private

  def common_expectations(upper_half:, lower_half:, middle:)
    expect(subject.upper_half).to eq(upper_half)
    expect(subject.lower_half).to eq(lower_half)
    expect(subject.middle).to eq(middle)
  end
end
