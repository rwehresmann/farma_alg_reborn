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
    describe '#check_answer' do
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

    describe '#score_to_earn' do
      context "when question is a challenge" do
        let(:answer) { build(:answer, question: create(:question, :challenge)) }
        let(:received) { answer.send(:score_to_earn) }

        it "returns the question score" do
          expect(received).to eq(answer.question.score)
        end
      end

      context "when question is a task" do
        let(:team) { create(:team) }
        let(:question) { create(:question) }
        let(:answer) { build(:answer, question: question, team: team) }
        let(:received) { answer.send(:score_to_earn) }

        context "when the limit to start variation is reached" do
          before do
            Answer::LIMIT_TO_START_VARIATION.times do
              create_right_answer_to_question(question, team: team)
            end
          end

          it "returns the score after applied the variation" do
            expect(received).not_to eql(answer.question.score)
          end
        end

        context "when the limit to start variation isn't reached" do
          before do
            (Answer::LIMIT_TO_START_VARIATION - 1).times do
              create_right_answer_to_question(question, team: team)
            end
          end

          it "returns the original question score" do
            expect(received).to eql(answer.question.score)
          end
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

  describe ".to_compare_similarity" do
    let(:answer) { create(:answer) }
    let(:expected) { [create(:answer, question: answer.question,
                            team: answer.team)]  }

    it "returns all answers except the specified answer" do
      expect(described_class.to_compare_similarity(answer)).to eq(expected)
    end
  end

  describe ".created_last" do
    before do
      today = Time.now
      2.times { |i| create(:answer, created_at: today + i.day) }
    end

    it "returns data ordered by time creation" do
      received = Answer.created_last
      expect(received.first.created_at > received.last.created_at).to be_truthy
    end
  end

  describe ".correct_status" do
    let(:answers) { Answer.all }

    before do
      create(:answer)
      create(:answer, :correct)
    end

    context "when status is passed" do
      it "returns the correct data" do
        [true, false].each do |status|
          expect(Answer.correct_status(status)).to eq(answers.where(correct: status))
        end
      end
    end
  end

  describe ".between_dates" do
    let(:start_date) { '2017-01-01' }
    let(:end_date) { '2017-01-02' }
    let!(:answer_1) { create(:answer, created_at: start_date) }
    let!(:answer_2) { create(:answer, created_at: end_date) }

    before { create(:answer, created_at: answer_2.created_at + 1.day) }

    context "when arguments are informed" do
      it "returns the answers in the date range" do
        expected = [answer_1, answer_2]
        expect(Answer.between_dates(start_date, end_date).to_a).to eq(expected)
      end
    end

    context "when aruments aren't informed" do
      it "returns all answers" do
        expect(Answer.between_dates(nil, nil)).to eq(Answer.all)
      end
    end
  end

  describe ".by_key_words" do
    let!(:to_return) { create(:answer, content: "This test should return") }

    before do
      create(:answer, content: "This not")
      Answer.reindex
    end

    it "returns the right answer" do
      expect(Answer.by_key_words("test").to_a).to eq([to_return])
    end
  end
end
