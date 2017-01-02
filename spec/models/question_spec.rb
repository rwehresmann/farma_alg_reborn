require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "Validations -->" do
    let(:question) { build(:question) }

    it "is valid with valid attributes" do
      expect(question).to be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to exercise" do
      expect(relationship_type(Question, :exercise)).to eq(:belongs_to)
    end

    it "has many test cases" do
      expect(relationship_type(Question, :test_cases)).to eq(:has_many)
    end
  end
end
