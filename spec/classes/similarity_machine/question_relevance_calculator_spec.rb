require 'rails_helper'

describe SimilarityMachine::QuestionRelevanceCalculator do
  describe "#calculate" do
    context "when there are answers to compare" do
      it "returns the relevance value" do
        users = create_list(:user, 3)
        teams = create_pair(:team)
        questions = create_pair(:question)

        answers = answers_hash(
          users: users,
          teams: teams, questions: questions)

        # answers_hash only creates 1 one for each case, here we needed 2.
        # Provisionally, this extra answer was created separately below.
        answer = create(
          :answer,
          team: teams[0],
          question: questions[0],
          user: users[1]
        )

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answers[:user_1][:team_0][:question_0],
          similarity: 30
        )

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answer,
          similarity: 50
        )

        # These connections must be ignored >>

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_1][:question_0],
          answer_2: answers[:user_1][:team_1][:question_0],
          similarity: 1000
        )

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_1],
          answer_2: answers[:user_1][:team_0][:question_1],
          similarity: 1000
        )

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answers[:user_2][:team_0][:question_0],
          similarity: 1000
        )

        result = described_class.new(
          user_1: users[0],
          user_2: users[1],
          team: teams[0],
          question: questions[0]
        ).calculate

        expect(result).to eq 40
      end
    end

    context "when there aren't answers to compare" do
      it "returns 0" do
        result = described_class.new(
          user_1: create(:user),
          user_2: create(:user),
          team: create(:team),
          question: create(:question)
        ).calculate

        expect(result).to eq 0
      end
    end
  end
end
