require 'utils/similarity_machine/answers_calculator'

class ComputeAnswerSimilarityJob < ApplicationJob
  queue_as :answers_similarity

  # Compute the similarity between all answers to que same question in the
  # same team.
  def perform(answer_1)
    answers_to_compare = AnswerQuery.new.answers_to_compare(answer_1)

    answers_to_compare.each do |answer_2|
      similarity = SimilarityMachine::AnswersCalculator.new(
        answer_1,
        answer_2
      ).calculate_similarity

      AnswerConnection.create!(answer_1: answer_1, answer_2: answer_2,
                              similarity: similarity)
    end
  end
end
