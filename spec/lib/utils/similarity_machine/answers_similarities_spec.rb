require 'rails_helper'
require 'utils/similarity_machine/answers_similarities'

describe SimilarityMachine::AnswersSimilarities do
  describe '#more_similar' do
    context "when limiting the number of results to return" do
      it "returns resultts respecting the limit specified" do
        questions = create_pair(:question)
        users = create_list(:user, 4)
        teams = create_pair(:team)

        answers = answers_hash(
          users: users,
          teams: teams,
          questions: questions
        )

        set_common_sample_data(answers)

        similarities = described_class.new(
          users: users.first(3),
          question: questions[0],
          team: teams[0]
        ).more_similar(1)

        expected_result = [ [answers[:user_0][:team_0][:question_0], 80] ]

        expect(similarities).to eq expected_result
      end
    end

    context "without limiting the number of results to return" do
      it "returns all results" do
        questions = create_pair(:question)
        users = create_list(:user, 4)
        teams = create_pair(:team)

        answers = answers_hash(
          users: users,
          teams: teams,
          questions: questions
        )

        set_common_sample_data(answers)

        similarities = described_class.new(
          users: users.first(3),
          question: questions[0],
          team: teams[0]
        ).more_similar

        expected_result = [
          [answers[:user_0][:team_0][:question_0], 80],
          [answers[:user_2][:team_0][:question_0], 70],
          [answers[:user_1][:team_0][:question_0], 50]
        ]

        expect(similarities).to eq expected_result
      end
    end

    context "when there are no answers" do
      it "returns nil" do
        questions = create_pair(:question)
        users = create_pair(:user)
        teams = create_pair(:team)

        # These answers must be ignored >>

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
        ).more_similar

        expect(selected).to be_nil
      end
    end
  end

  def set_common_sample_data(answers)
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
      similarity: 20
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
  end
end
