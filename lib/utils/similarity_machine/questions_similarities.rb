require 'utils/similarity_machine/utils'
require 'utils/similarity_machine/questions_calculator'

module SimilarityMachine
  class QuestionsSimilarities
    include Utils

    def initialize(users:, team:)
      @users = users
      @team = team
      @similarities = search
    end

    def more_similar(limit = nil)
      limit ? @similarities.first(limit) : @similarities
    end

    private

    def search
      questions = common_questions_answered(users: @users, team: @team)
      return if questions.empty?

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

      sort_similarities_desc(similarities)
    end
  end
end
