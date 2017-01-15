require 'rails_helper'

RSpec.describe AnswerTestCaseResult, type: :model do
  describe "Validations -->" do
    let(:answer_test_case_result) { build(:answer_test_case_result) }

    it "is valid with valid attributes" do
      expect(answer_test_case_result).to be_valid
    end

    it "is invalid with empty output" do
      answer_test_case_result.output = ""
      expect(answer_test_case_result).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to test case" do
      expect(relationship_type(AnswerTestCaseResult, :test_case)).to eq(:belongs_to)
    end

    it "belongs to answer" do
      expect(relationship_type(AnswerTestCaseResult, :answer)).to eq(:belongs_to)
    end
  end
end
