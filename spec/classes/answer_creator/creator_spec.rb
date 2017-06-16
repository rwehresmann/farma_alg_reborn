require 'rails_helper'

describe AnswerCreator::Creator do
  describe "#create" do
    context "when is the first attempt of the user to answer this question" do
      it "creates the answer and related objects with the right data" do
        answer_test_case_result_count = AnswerTestCaseResult.count
        jobs_count = enqueued_jobs.size

        question = create(:question)
        create_pair(:test_case, question: question)
        answer = build(:answer, question: question)

        described_class.new(answer).create

        expect(answer.new_record?).to be_falsey
        expect(answer.attempt).to eq 1
        expect(AnswerTestCaseResult.count).to eq answer_test_case_result_count + 2
        expect(enqueued_jobs.size).to eq jobs_count + 1
      end
    end

    context "when isn't the first attempt of the user to answer this question" do
      it "creates the answer with the right attempt number, create the test case results and add the answer to be processed in background" do
        answer_test_case_result_count = AnswerTestCaseResult.count
        jobs_count = enqueued_jobs.size

        user = create(:user)
        team = create(:team)
        question = create(:question)
        create_pair(:test_case, question: question)
        create(:answer, question: question, user: user, team: team)
        answer = build(:answer, question: question, user: user, team: team)

        # These answers must be ignored >>
        create(:answer, question: question, user: user)
        create(:answer, question: question, team: team)
        create(:answer, user: user, team: team)

        described_class.new(answer).create

        expect(answer.new_record?).to be_falsey
        expect(answer.attempt).to eq 2
        expect(AnswerTestCaseResult.count).to eq answer_test_case_result_count + 2
        expect(enqueued_jobs.size).to eq jobs_count + 1
      end
    end
  end
end
