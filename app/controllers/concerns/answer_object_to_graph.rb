module AnswerObjectToGraph
  extend ActiveSupport::Concern

  # Create a hash with the necessary data to display in the graph.
  def answer_object_to_graph(answer)
    hash = {}
    hash.merge!(answer.slice(:id, :correct, :created_at).symbolize_keys)
    hash[:user] = answer.user.slice(:name).symbolize_keys
    hash[:question] = answer.question.slice(:title).symbolize_keys
    hash[:exercise] = answer.question.exercise.slice(:title).symbolize_keys
    hash
  end
end
