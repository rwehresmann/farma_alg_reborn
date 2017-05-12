require 'rails_helper'
require 'utils/similarity_machine/users_calculator'

describe SimilarityMachine::UsersCalculator do
  before { @team = create(:team) }

  describe '#calculate_similarity' do
    context "when users haven't common questions answered" do
      subject do
        users = users_without_common_questions
        described_class.new(
          user_1: users[0], user_2: users[1], team: @team
        ).calculate_similarity
      end

      it { is_expected.to be_nil }
    end

    context "when users have common questions answered" do
      subject do
        users = users_with_similar_answers
        described_class.new(
          user_1: users[0], user_2: users[1], team: @team
        ).calculate_similarity
      end

      it { is_expected.to eq 75 }
    end
  end

  def users_without_common_questions
    users = create_pair(:user)
    users.each { |user| create(:answer, team: @team, user: user) }
    users
  end

  def users_with_similar_answers
    users = create_pair(:user)
    answers = answers_to_create_connections(
      users: users, team: @team
    )

    create(
      :answer_connection,
      answer_1: answers[:user_1][:question_1],
      answer_2: answers[:user_2][:question_1],
      similarity: 50
    )
    create(
      :answer_connection,
      answer_1: answers[:user_1][:question_2],
      answer_2: answers[:user_2][:question_2],
      similarity: 100
    )

    users
  end

  def answers_to_create_connections(users:, team:)
    questions = create_pair(:question)
    answers = {}

    answers[:user_1] = {
      question_1: create(:answer, team: team, user: users[0], question: questions[0]),
      question_2: create(:answer, team: team, user: users[0], question: questions[1]),
    }
    answers[:user_2] = {
      question_1: create(:answer, team: team, user: users[1], question: questions[0]),
      question_2: create(:answer, team: team, user: users[1], question: questions[1]),
    }

    answers
  end
end
