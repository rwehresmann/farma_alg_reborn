class Recommendator
  def initialize(team)
    @team = team
  end

  def search_and_create_recommendations
    get_team_questions.each do |question|
      graph = add_answers_connections_in_graph(question)
      connected_components = graph.connected_components

      connected_components.each do |connected_component|
        users = get_users_from_connected_component
        create_recommendation(question, users, answers)
      end
    end
  end

  private

  def get_team_questions
    @team.exercises.each.inject([]) { |questions, exercise|
      exercise.questions.map { |question| questions << question }
    }
  end

  def get_simmilar_answers(question)
    answers = Answer.where(question: question, team: @team)
    connections = AnswersConnectionsQuery.new(answers).call
    connections.select { |connection|
      connection.similarity >= Figaro.env.similarity_threshold.to_f
    }
  end

  def add_answers_connections_in_graph(question, graph = Graph.new)
    connections = get_simmilar_answers(question)

    connections.each { |connection|
      graph.add_edge(connection[:answer_1], connection[:answer_2])
    }

    graph
  end

  def get_users_from_connected_component(connected_component)
    connected_component.map(&:user)
  end

  def create_recommendation(question, users, answers)
    Recommendation.create!(
      team: @team,
      question: question,
      users: users,
      answers: answers
    )
  end
end
