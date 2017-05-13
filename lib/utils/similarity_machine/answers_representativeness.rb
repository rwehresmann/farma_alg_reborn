require 'utils/similarity_machine/utils'

module SimilarityMachine
  class AnswersRepresentativeness
    include Utils

    def initialize(question:, users:, team:)
      @questions = question
      @users = users
      @team = team
    end

    def most_representative
      answers = AnswerQuery.new.user_answers(
        @users,
        to: { question: @question, team: @team }
      ).to_a

      return if answers.empty?
      answers_similarities(answers).key_of_biggest_value
    end

    private

    def answers_similarities(answers)
      similarities = Hash.new(0)
      compare_and_shift_each(answers, similarities) do |answer_1, answer_2|
        similarity = answer_1.similarity_with(answer_2)
        similarities[answer_1] += similarity unless similarity.nil?
      end

      similarities
    end
  end
end
