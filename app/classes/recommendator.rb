require 'utils/graph'

class Recommendator
  def initialize(team)
    @team = team
  end

  def search_and_create_recommendations
    get_team_questions.each do |question|
      graph = add_answers_connections_in_graph(question)
      connected_components = graph.connected_components

      connected_components.each { |answers|
        create_recommendation(question, answers.map(&:id))
      }
    end
  end

  private

  def get_team_questions
    @team.exercises.each.inject([]) { |questions, exercise|
      exercise.questions.each { |question| questions << question }
    }
  end

  def get_similar_answers(question)
    answers = Answer.where(question: question, team: @team)
    connections = AnswersConnectionsQuery.new(answers).call
    connections.select { |connection|
      connection.similarity >= Figaro.env.similarity_threshold.to_f
    }
  end

  def add_answers_connections_in_graph(question, graph = Graph.new)
    connections = get_similar_answers(question)

    connections.each { |connection|
      graph.add_edge(connection.answer_1, connection.answer_2)
    }

    graph
  end

  def create_recommendation(question, answers_ids)
    Recommendation.create!(
      team: @team,
      question: question,
      answers: answers_ids
    ) unless recommendation_already_exists?(question, answers_ids)
  end

  def recommendation_already_exists?(question, answers_ids)
    recommendations = Recommendation.where(question: question, team: @team)
    recommendations.each { |recommendation|
      return true if recommendation.answers.sort == answers_ids.sort
    }

    false
  end
end
