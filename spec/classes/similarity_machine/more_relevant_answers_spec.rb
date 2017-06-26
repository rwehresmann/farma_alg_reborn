require 'rails_helper'

describe SimilarityMachine::MoreRelevantAnswers do
  describe '#get' do
    context "when there are relevant answers" do
      it "returns them" do
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

        expect(result.count).to eq 2
        expect(result[0][:answer]).to eq answers[:user_1][:team_0][:question_0]
        expect(result[1][:answer]).to eq answers[:user_2][:team_0][:question_0]
      end
    end

    context "when there aren't relevant answers" do
      it "returns an empty array" do

      end
    end
  end

  def set_connections(answers)
    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_0],
      answer_2: answers[:user_1][:team_0][:question_0],
      similarity: Figaro.env.similarity_threshold.to_f
    )

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_0],
      answer_2: answers[:user_2][:team_0][:question_0],
      similarity: Figaro.env.similarity_threshold.to_f - 1
    )

    create(
      :answer_connection,
      answer_1: answers[:user_1][:team_0][:question_0],
      answer_2: answers[:user_2][:team_0][:question_0],
      similarity: Figaro.env.similarity_threshold.to_f + 10
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
