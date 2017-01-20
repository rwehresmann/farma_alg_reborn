require 'rails_helper'

RSpec.describe AnswerTestCaseResult, type: :model do
  describe "Validations -->" do
    before(:all) { @answer_test_case_result = build(:answer_test_case_result) }

    it "is valid with valid attributes" do
      expect(@answer_test_case_result).to be_valid
    end

    it "is invalid with empty output" do
      @answer_test_case_result.output = ""
      expect(@answer_test_case_result).to_not be_valid
    end

    context "when is tryied to create a new record to the answer and test case" do
      it "raise an error" do
        expect { @answer_test_case_result.dup.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
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

  describe ".result" do
    let(:question) { create(:question, test_cases_count: 1) }
    let!(:test_case) { create(:test_case, question: question) }
    let(:answer) { create(:answer, question: question) }
    let(:result) { AnswerTestCaseResult.result(answer, test_case) }

    it "returns the correct result" do
      expect(result.test_case).to eq(test_case)
      expect(result.answer).to eq(answer)
    end
  end
end
