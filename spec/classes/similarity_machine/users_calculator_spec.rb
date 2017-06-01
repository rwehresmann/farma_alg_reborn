require 'rails_helper'

describe SimilarityMachine::UsersCalculator do
  before { @team = create(:team) }

  describe '#calculate_similarity' do
    context "when users haven't common questions answered" do
      it "returns nil" do
        team = create(:team)
        users = create_pair(:user)
        users.each { |user| create(:answer, team: team, user: user) }

        similarity = described_class.new(
          user_1: users[0],
          user_2: users[1],
          team: team
        ).calculate_similarity

        expect(similarity).to be_nil
      end
    end

    context "when users have common questions answered" do
      subject do
        users = users_with_similar_answers
        described_class.new(
          user_1: users[0], user_2: users[1], team: @team
        ).calculate_similarity
      end

      it "returns the similarity based in these questions answers connections" do
        users = create_list(:user, 3)
        teams = create_pair(:team)
        questions = create_pair(:question)

        answers = answers_hash(users: users, teams: teams, questions: questions)

        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_0],
          answer_2: answers[:user_1][:team_0][:question_0],
          similarity: 50
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_1],
          answer_2: answers[:user_1][:team_0][:question_1],
          similarity: 100
        )

        # Must be avoided >>
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_0][:question_1],
          answer_2: answers[:user_2][:team_0][:question_1],
          similarity: 72
        )
        create(
          :answer_connection,
          answer_1: answers[:user_0][:team_1][:question_1],
          answer_2: answers[:user_1][:team_1][:question_1],
          similarity: 87
        )

        similarity = described_class.new(
          user_1: users[0],
          user_2: users[1],
          team: teams[0]
        ).calculate_similarity

        expect(similarity).to eq 75
      end
    end
  end
end
