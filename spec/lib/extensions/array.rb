require 'rails_helper'
require 'extensions/array'

describe Array do
  describe '#avg' do
    let(:result) { [7,7,7].avg }
    it "is defined" do
      expect([].respond_to? :avg).to be_truthy
    end

    it "returns the average and its float type" do
      expect(result).to eq(7)
      expect(result.class).to eq(Float)
    end
  end

  describe ".common_values" do
    let(:array) { [1,2,3,4,5] }

    it "returns the common values of both arrays" do
      expect(array.common_values([1,2,6,7,8,9])).to eq([1,2])
      expect(array.common_values([6,7,8,9])).to eq([])
    end
  end

  describe '#common_arrays_values' do
    let(:arrays_group) { [[1,2,3,4,5], [2,3,4], [1,2,3]] }

    it "returns the common values in the arrays collection" do
      expect(arrays_group.common_arrays_values).to eq([2,3])
    end
  end
end
