require 'rails_helper'
require 'utils/similarity_machine/answers_representativeness'

describe SimilarityMachine::AnswersRepresentativeness do
  describe '#most_representative' do
    context "when there are no answers" do
      it "returns nil" do
        questions = create_pair(:question)
        users = create_pair(:user)
        teams = create_pair(:team)

        # These answers must be ignored
        answers = answers_hash(
          users: users,
          teams: [teams[1]],
          questions: questions
        )

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answers[:user_1][:team_0][:question_0],
          similarity: 100
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_1],
          answer_2: answers[:user_1][:team_0][:question_1],
          similarity: 100
        )

        selected = described_class.new(
          users: users,
          question: questions[0],
          team: teams[0]
        ).most_representative

        expect(selected).to be_nil
      end
    end

    context "when there are answers" do
      it "returns the most representative answers of the specified questions and users group" do
        questions = create_pair(:question)
        users = create_list(:user, 4)
        teams = create_pair(:team)

        # These answers must be ignored
        answers = answers_hash(
          users: users,
          teams: teams,
          questions: questions
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
          answer_2: answers[:user_2][:team_0][:question_0],
          similarity: 50
        )
        create(
          :answer_connection,
          answer_1: answers[:user_1][:team_0][:question_0],
          answer_2: answers[:user_2][:team_0][:question_0],
          similarity: 30
        )

        # These answers must be ignored >>
        create(
          :answer_connection,
          answer_1: answers[:user_1][:team_0][:question_1],
          answer_2: answers[:user_2][:team_0][:question_1],
          similarity: 100
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answers[:user_3][:team_0][:question_0],
          similarity: 100
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_1][:question_0],
          answer_2: answers[:user_1][:team_1][:question_0],
          similarity: 100
        )

        selected = described_class.new(
          users: users.first(3),
          question: questions[0],
          team: teams[0]
        ).most_representative

        expect(selected).to eq answers[:user_0][:team_0][:question_0]
      end
    end
  end
end
