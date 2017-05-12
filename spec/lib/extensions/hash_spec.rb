require 'rails_helper'

describe Hash do
  describe '#key_of_biggest_value' do
    context "with expected cases" do
      it { expect({ a: 1.1, b: 2, c: 3}.key_of_biggest_value).to eq :c }
      it { expect({ a: 3.1, b: 2, c: 3}.key_of_biggest_value).to eq :a }
      it { expect({ a: 1.1, b: 2, c: 5, d: 4.5}.key_of_biggest_value).to eq :c }
    end

    context "with values that aren't numbers" do
      it { expect { { a: nil, b: 2}.key_of_biggest_value }.to raise_error(RuntimeError) }
      it { expect{ { a: 2, b: ""}.key_of_biggest_value }.to raise_error(RuntimeError) }
    end
  end
end
