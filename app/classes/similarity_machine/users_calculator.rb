module SimilarityMachine
  class UsersCalculator
    include Utils

    def initialize(user_1:, user_2:, team:)
      @user_1 = user_1
      @user_2 = user_2
      @team = team
    end

    def calculate_similarity
      questions = common_questions_answered(
        users: [@user_1, @user_2],
        team: @team
      )

      return if questions.empty?

      calculator = QuestionsCalculator.new(
        user_1: @user_1, user_2: @user_2, team: @team
      )
      calculator.calculate_similarity(questions)
    end

    private

    def common_questions_answered(users:, team:)
      groups = []
      compare_and_shift_each(users, groups) do |user_1, user_2|
        users_questions = [user_1, user_2].map { |user|
          QuestionQuery.new.questions_answered_by_user(user, team: team).to_a
        }
        groups << users_questions.common_arrays_values
      end

      groups.common_arrays_values
    end
  end
end
