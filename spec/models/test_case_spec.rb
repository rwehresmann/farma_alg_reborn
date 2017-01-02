require 'rails_helper'

RSpec.describe TestCase, type: :model do
  describe "Validations -->" do
    let(:test_case) { build(:test_case) }

    it "is valid with valid attributes" do
      expect(test_case).to be_valid
    end

    it "is invalid with empty input" do
      test_case.input = ""
      expect(test_case).to_not be_valid
    end

    it "is invalid with empty output" do
      test_case.output = ""
      expect(test_case).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to question" do
      expect(relationship_type(TestCase, :question)).to eq(:belongs_to)
    end
  end
end
