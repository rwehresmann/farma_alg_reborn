require 'utils/similarity_machine/utils'
require 'utils/similarity_machine/questions_calculator'

module SimilarityMachine
  class QuestionsRepresentativeness
    include Utils

    def initialize(users:, team:)
      @users = users
      @team = team
    end

    def most_representative
      questions = common_questions_answered(users: @users, team: @team)
      return if questions.empty?
      questions_similarities(questions).key_of_biggest_value
    end

    private

    def questions_similarities(questions)
      similarities = Hash.new(0)
      compare_and_shift_each(@users, similarities) do |user_1, user_2|
        questions.each do |question|
          calculator = QuestionsCalculator.new(
            user_1: user_1,
            user_2: user_2,
            team: @team
          )
          similarity = calculator.calculate_similarity([question])
          similarities[question] += similarity unless similarity.nil?
        end
      end

      similarities
    end
  end
end
