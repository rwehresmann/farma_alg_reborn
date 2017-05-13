require 'rails_helper'
require 'utils/similarity_machine/questions_representativeness'

describe SimilarityMachine::QuestionsRepresentativeness do
  describe '#most_representative' do
    context "when users haven't common questions answered" do
      it "returns nil" do
        users = create_pair(:user)
        teams = create_pair(:team)
        question = create(:question)

        # Must be ignored
        users.each { |user|
          create(:answer, user: user, team: teams[1], question: question)
        }

        selected = described_class.new(
          users: users,
          team: teams[0]
        ).most_representative

        expect(selected).to be_nil
      end
    end

    context "when users have common questions answered" do
      it "choose the most representative question to the group of users" do
        users = create_list(:user, 3)
        teams = create_list(:team, 2)
        questions = create_list(:question, 3)

        answers = answers_hash(users: users, teams: teams, questions: questions)

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answers[:user_1][:team_0][:question_0],
          similarity: 70.3
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_1],
          answer_2: answers[:user_1][:team_0][:question_1],
          similarity: 75
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_2],
          answer_2: answers[:user_1][:team_0][:question_2],
          similarity: 10
        )

        # Must be ignored >>
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answers[:user_2][:team_0][:question_0],
          similarity: 100
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_1][:question_0],
          answer_2: answers[:user_1][:team_1][:question_0],
          similarity: 70.3
        )

        selected = described_class.new(
          users: users.first(2),
          team: teams[0]
        ).most_representative

        expect(selected).to eq(questions[1])
      end
    end
  end
end
