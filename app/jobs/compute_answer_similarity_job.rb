require 'utils/similarity_machine'

class ComputeAnswerSimilarityJob < ApplicationJob
  include SimilarityMachine

  queue_as :answers_similarity

  # Compute the similarity between all answers to que same question in the
  # same team.
  def perform(answer_1)
    to_compare = Answer.to_compare_similarity(answer_1)
    to_compare.each do |answer_2|
      similarity = answers_similarity(answer_1, answer_2)
      AnswerConnection.create_simetrical_record(answer_1, answer_2, similarity)
    end
  end
end
