require 'utils/similarity_machine/questions_calculator'
require 'utils/similarity_machine/utils'

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
  end
end
