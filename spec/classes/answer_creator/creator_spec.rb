require 'rails_helper'

describe AnswerCreator::Creator do
  describe "#create" do
    context "when the question was already correct answerd by the student" do
      it "doesn t increase user score" do
        answer_test_case_result_count = AnswerTestCaseResult.count

        team = create(:team)
        question = create(:question, test_cases: [create(:test_case, :hello_world)])
        create_pair(:test_case, question: question)
        answers = create_pair(:answer, :hello_world, question: question, team: team, correct: true)
        user_score = create(:user_score, user: answers.first.user, team: answers.first.team)

        described_class.new(answers.last).create

        expect(enqueued_jobs.size).to eq 0
        expect(AnswerTestCaseResult.count).to eq answer_test_case_result_count + 1
        expect(user_score.score).to eq user_score.reload.score
      end
    end

    context "when is the first attempt of the user to answer this question" do
      it "creates the answer and related objects with the right data" do
        answer_test_case_result_count = AnswerTestCaseResult.count
        jobs_count = enqueued_jobs.size

        question = create(:question, test_cases: [create(:test_case, :hello_world)])
        create_pair(:test_case, question: question)
        answer = build(:answer, :hello_world, question: question, correct: true)
        create(:user_score, user: answer.user, team: answer.team)

        increaser_call_expectation(answer)

        described_class.new(answer).create

        expect(answer.new_record?).to be_falsey
        expect(answer.attempt).to eq 1
        expect(AnswerTestCaseResult.count).to eq answer_test_case_result_count + 1
        #expect(enqueued_jobs.size).to eq jobs_count + 1
      end
    end

    context "when isn't the first attempt of the user to answer this question" do
      it "creates the answer with the right attempt number, create the test case results and add the answer to be processed in background" do
        answer_test_case_result_count = AnswerTestCaseResult.count
        jobs_count = enqueued_jobs.size

        user = create(:user)
        team = create(:team)
        question = create(:question, test_cases: [create(:test_case, :hello_world)])
        create_pair(:test_case, question: question)
        create(:answer, question: question, user: user, team: team)
        answer = build(:answer, :hello_world, question: question, user: user, team: team)
        create(:user_score, user: answer.user, team: answer.team)

        # These answers must be ignored >>
        create(:answer, question: question, user: user)
        create(:answer, question: question, team: team)
        create(:answer, user: user, team: team)

        increaser_call_expectation(answer)

        described_class.new(answer).create

        expect(answer.new_record?).to be_falsey
        expect(answer.attempt).to eq 2
        expect(AnswerTestCaseResult.count).to eq answer_test_case_result_count + 1
        #expect(enqueued_jobs.size).to eq jobs_count + 1
      end
    end
  end

  context "#test_cases_results" do
    it "returns the test cases results" do
      question = create(:question)
      create_pair(:test_case, question: question)
      answer = build(:answer, question: question)

      creator = described_class.new(answer)

      expect(creator.test_cases_results.count).to eq 2
    end
  end

  def increaser_call_expectation(answer)
    fake_increaser = AnswerCreator::ScoreIncreaser.new(
      user: answer.user,
      team: answer.team,
      question: answer.question
    )
    expect(AnswerCreator::ScoreIncreaser).to receive(:new)
      .with(
        user: answer.user,
        team: answer.team,
        question: answer.question
      )
      .and_return fake_increaser

    expect(fake_increaser).to receive(:increase).and_call_original
  end
end
