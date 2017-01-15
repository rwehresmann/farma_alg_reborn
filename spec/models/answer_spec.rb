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

    it "has many test cases results" do
      expect(relationship_type(Answer, :test_cases_results)).to eq(:has_many)
    end
  end

  describe "Callbacks -->" do
    describe '#set_correct (before_create)' do
      let!(:question) { create(:question) }

      context "when is correct answered" do
        let!(:answer) { create_right_answer_to_question(question) }

        it "is setted as true" do
          expect(answer.correct).to be_truthy
        end
      end

      context "when answer isn't correct answered" do
        let(:answer) { create_wrong_answer_to_question(question) }

        it "is setted as false" do
          expect(answer.correct).to be_falsey
        end
      end

      context "when answer doesn't compile successfully" do
        let(:answer) { create_wrong_answer_to_question(question) }

        it "is setted as false" do
          expect(answer.correct).to be_falsey
        end
      end
    end

    describe '#save_test_cases_result (after_create)' do
      let(:question) { create(:question, test_cases_count: 2) }
      before { create(:answer, question: question) }

      it "saves the test cases result" do
        expect(AnswerTestCaseResult.all.count).to eq(question.test_cases.count)
      end

      it "sets the output" do
        expect(AnswerTestCaseResult.first.output).to_not be_nil
      end
    end
  end
end
