require 'utils/similarity_machine'

class ComputeSimilarityJob < ApplicationJob
  include SimilarityMachine

  queue_as :default

  # Compute the similarity between all answers to que same question in the
  # same team.
  def perform(answer_1)
    to_compare = Answer.all_team_answers_to_question(answer_1.team, answer_1.question, except: answer_1)
    to_compare.each do |answer_2|
      similarity = answers_similarity(answer_1, answer_2)
      AnswerConnection.create_simetrical_record(answer_1, answer_2, similarity)
    end
  end
end
