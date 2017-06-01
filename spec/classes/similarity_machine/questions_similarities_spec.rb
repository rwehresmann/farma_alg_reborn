require 'rails_helper'

describe SimilarityMachine::QuestionsSimilarities do
  describe '#more_similar' do
    context "when users haven't common questions answered" do
      it "returns nil" do
        users = create_pair(:user)
        teams = create_pair(:team)
        question = create(:question)

        # Must be ignored
        users.each { |user|
          create(:answer, user: user, team: teams[1], question: question)
        }

        similarities = described_class.new(
          users: users,
          team: teams[0]
        ).more_similar

        expect(similarities).to be_nil
      end
    end

    context "when users have common questions answered" do
      context "when limiting the number of results to return" do
        it "returns results respecting the limit specified" do
          users = create_list(:user, 3)
          teams = create_list(:team, 2)
          questions = create_list(:question, 3)

          set_common_sample_data(users, teams, questions)

          similarities = described_class.new(
            users: users.first(2),
            team: teams[0]
          ).more_similar(2)

          expected_result = [
            [questions[1], 75],
            [questions[0], 70.3]
          ]

          expect(similarities).to eq expected_result
        end
      end

      context "without limiting the number of results to return" do
        it "returns all results" do
          users = create_list(:user, 3)
          teams = create_list(:team, 2)
          questions = create_list(:question, 3)

          set_common_sample_data(users, teams, questions)

          similarities = described_class.new(
            users: users.first(2),
            team: teams[0]
          ).more_similar

          expected_result = [
            [questions[1], 75],
            [questions[0], 70.3],
            [questions[2], 10]
          ]

          expect(similarities).to eq expected_result
        end
      end
    end
  end

  def set_common_sample_data(users, teams, questions)
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
  end
end
