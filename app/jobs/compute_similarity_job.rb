require 'utils/similarity_machine'

class ComputeSimilarityJob < ApplicationJob
  include SimilarityMachine

  queue_as :default

  def perform(answer)
    
  end
end
