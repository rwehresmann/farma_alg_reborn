require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "Validations -->" do
    let(:answer) { build(:answer) }

    it "is valid with valid attributes" do
      expect(answer).to be_valid
    end

    it "is invalid with empty content" do
      answer.content = ""
      expect(answer).to_not be_valid
    end

    it "is invalid with empty correct flag" do
      answer.correct = ""
      expect(answer).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to user" do
      expect(relationship_type(Answer, :user)).to eq(:belongs_to)
    end

    it "belongs to question" do
      expect(relationship_type(Answer, :question)).to eq(:belongs_to)
    end

    it "belongs to team" do
      expect(relationship_type(Answer, :team)).to eq(:belongs_to)
    end

    it "has many test cases results" do
      expect(relationship_type(Answer, :test_cases_results)).to eq(:has_many)
    end

    it "has many similarities" do
      expect(relationship_type(Answer, :similarities)).to eq(:has_many)
    end
  end

  describe "Callbacks -->" do
    describe '#before_create' do
      let!(:question) { create(:question) }

      context "when is correct answered" do
        let!(:answer) { create_right_answer_to_question(question, callbacks: true) }

        it "flags are right setted and a record in earned_scores is created" do
          expect(answer.correct).to be_truthy
          expect(answer.compilation_error).to be_falsey
          expect(answer.compiler_output).to_not be_nil
          expect(EarnedScore.count).to eq(1)
        end
      end

      context "when answer isn't correct answered, but compiled successfully" do
        let(:answer) { create_wrong_answer_to_question(question, callbacks: true) }

        it "correct is setted as false and compilation_error as false too" do
          expect(answer.correct).to be_falsey
          expect(answer.compilation_error).to be_falsey
          expect(answer.compiler_output).to_not be_nil
        end
      end

      context "when answer doesn't compile successfully" do
        let(:answer) { create_answer_whit_compilation_error_to_question(question, callbacks: true) }

        it "answer is setted as false and compilation_error too" do
          expect(answer.correct).to be_falsey
          expect(answer.compilation_error).to be_truthy
          expect(answer.compiler_output).to_not be_nil
        end
      end
    end

    describe '#after_create' do
      let(:question) { create(:question) }
      let(:results_count) { Proc.new { |answer| AnswerTestCaseResult.where(answer: answer).count } }

      context "when is correct answered" do
        let!(:answer) { create_right_answer_to_question(question, callbacks: true) }

        it "saves the test cases result" do
          expect(question.test_cases.count > 0).to be_truthy
          expect(results_count.call(answer)).to eq(question.test_cases.count)
        end
      end

      context "when answer isn't correct answered, but compiled successfully" do
        let!(:answer) { create_wrong_answer_to_question(question, callbacks: true) }

        it "saves the test cases result" do
          expect(question.test_cases.count > 0).to be_truthy
          expect(results_count.call(answer)).to eq(question.test_cases.count)
        end
      end

      context "when answer doesn't compile successfully" do
        let!(:answer) { create_answer_whit_compilation_error_to_question(question, callbacks: true) }

        it "saves the test cases result" do
          expect(question.test_cases.count > 0).to be_truthy
          expect(results_count.call(answer)).to eq(0)
        end
      end
    end
  end
end
