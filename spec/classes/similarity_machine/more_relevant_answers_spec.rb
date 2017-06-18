require 'rails_helper'

describe SimilarityMachine::MoreRelevantAnswers do
  describe '#get' do
    context "when there are answers to compare" do
      context "when limiting the number of answers to return" do
        it "returns the more relevant answers respecting the limit informed" do
          users = create_list(:user, 4)
          teams = create_pair(:team)
          questions = create_pair(:question)

          answers = answers_hash(users: users, teams: teams, questions: questions)
          set_connections(answers)

          result = described_class.new(
            question: questions[0],
            users: users.first(3),
            team: teams[0]
          ).get(2)

          expect(result.count).to eq 2
          expect(result[0][0]).to eq answers[:user_0][:team_0][:question_0]
          expect(result[1][0]).to eq answers[:user_2][:team_0][:question_0]
        end
      end

      context "without limiting the number of answers to return" do
        it "returns the more relevante answers" do
          users = create_list(:user, 4)
          teams = create_pair(:team)
          questions = create_pair(:question)

          answers = answers_hash(users: users, teams: teams, questions: questions)
          set_connections(answers)

          result = described_class.new(
            question: questions[0],
            users: users.first(3),
            team: teams[0]
          ).get

          expect(result.count).to eq 3
          expect(result[0][0]).to eq answers[:user_0][:team_0][:question_0]
          expect(result[1][0]).to eq answers[:user_2][:team_0][:question_0]
          expect(result[2][0]).to eq answers[:user_1][:team_0][:question_0]
        end
      end
    end

    context "when the aren't answers to compare" do
      it "returns an empty array" do
        result = described_class.new(
          question: create(:question),
          users: create_pair(:user),
          team: create(:team)
        ).get

        expect(result).to eq []
      end
    end
  end

  def set_connections(answers)
    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_0],
      answer_2: answers[:user_1][:team_0][:question_0],
      similarity: 30
    )

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_0],
      answer_2: answers[:user_2][:team_0][:question_0],
      similarity: 50
    )

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_0],
      answer_2: answers[:user_3][:team_0][:question_0],
      similarity: 40
    )

    # These connections must be ignored >>

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_0],
      answer_2: answers[:user_3][:team_0][:question_0],
      similarity: 1000
    )

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_1][:question_0],
      answer_2: answers[:user_1][:team_1][:question_0],
      similarity: 1000
    )

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_1],
      answer_2: answers[:user_2][:team_0][:question_1],
      similarity: 1000
    )
  end
end
