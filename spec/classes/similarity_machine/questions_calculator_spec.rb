require 'rails_helper'

describe SimilarityMachine::QuestionsCalculator do
  before do
    @question = create(:question)
    @team = create(:team)
  end

  describe '#questions_similarity' do
    context "when questions aren't informed" do
      subject {
        described_class.new(
          user_1: create(:user),
          user_2: create(:user),
          team: create(:team)
        ).calculate_similarity([])
      }

      it {
        expect { subject }.to raise_error(ArgumentError)
      }
    end

    context "when questions are informed" do
      context "when none answers of the users have its similarity calculated already" do
        it "returns 0% of similarity" do
          users = create_list(:user, 3)
          teams = create_pair(:team)
          questions = create_list(:question, 3)

          answers = answers_hash(
            users: users,
            teams: teams,
            questions: questions
          )

          create_connections_who_must_be_avoided(answers)

          similarity = described_class.new(
            user_1: users[0],
            user_2: users[1],
            team: teams[0]
          ).calculate_similarity(questions.first(2))

          expect(similarity).to eq 0
        end
      end

      context "when some users answers have its similarity calculated already" do
        context "when they're completely similar" do
          it "returns 100% of similarity" do
            users = create_list(:user, 3)
            teams = create_pair(:team)
            questions = create_list(:question, 3)

            answers = answers_hash(
              users: users,
              teams: teams,
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

            create_connections_who_must_be_avoided(answers)

            similarity = described_class.new(
              user_1: users[0],
              user_2: users[1],
              team: teams[0]
            ).calculate_similarity(questions.first(2))

            expect(similarity).to eq 100
          end
        end

        context "when they're similar in some level" do
          it "returns something >= 0% and <= 100% of similarity" do
            users = create_list(:user, 3)
            teams = create_pair(:team)
            questions = create_list(:question, 3)

            answers = answers_hash(
              users: users,
              teams: teams,
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
              similarity: 50
            )

            create_connections_who_must_be_avoided(answers)

            similarity = described_class.new(
              user_1: users[0],
              user_2: users[1],
              team: teams[0]
            ).calculate_similarity(questions.first(2))

            expect(similarity).to eq 75
          end
        end

        context "when they're completely different" do
           it "returns 0% of similarity" do
             users = create_list(:user, 3)
             teams = create_pair(:team)
             questions = create_list(:question, 3)

             answers = answers_hash(
               users: users,
               teams: teams,
               questions: questions
             )

             create(
               :answer_connection,
               answer_1: answers[:user_0][:team_0][:question_0],
               answer_2: answers[:user_1][:team_0][:question_0],
               similarity: 0
             )

             create(
               :answer_connection,
               answer_1: answers[:user_0][:team_0][:question_1],
               answer_2: answers[:user_1][:team_0][:question_1],
               similarity: 0
             )

             create_connections_who_must_be_avoided(answers)

             similarity = described_class.new(
               user_1: users[0],
               user_2: users[1],
               team: teams[0]
             ).calculate_similarity(questions.first(2))

             expect(similarity).to eq 0
           end
        end
      end
    end
  end

  # This method shares common data setup from the tests, creating answers
  # connections who must not be considered because doesn't match with the
  # arguments informed do AnswersCalculator and its calculate_similarity method
  # (this helps to test unexpected behavior in the tests).
  # The tests area configured with:
  # - 3 users, where users[2] must be avoided;
  # - 2 teams, where teams[1] must be avoided;
  # - 3 questions, where questions[2] must be avoided.
  def create_connections_who_must_be_avoided(answers)
    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_1][:question_0],
      answer_2: answers[:user_2][:team_1][:question_0],
      similarity: 94
    )

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_1][:question_0],
      answer_2: answers[:user_1][:team_1][:question_0],
      similarity: 86
    )

    create(
      :answer_connection,
      answer_1: answers[:user_0][:team_0][:question_2],
      answer_2: answers[:user_1][:team_0][:question_2],
      similarity: 32
    )
  end
end
