class Recommendator
  def initialize(team)
    @team = team
  end

  def search_and_create_recommendations
    users_graph = SimilarityMachine::UsersGraphGenerator.new(@team).generate
    relevant_questions = get_relevant_questions(users_graph)
    users = get_users_from_graph(users_graph)

    recommendations = []

    relevant_questions.each do |question|
      relevant_answers = SimilarityMachine::MoreRelevantAnswers.new(
        question: question,
        users: users,
        team: @team
      ).get

      recommendations << {
        question: question,
        answers: relevant_answers
      }
    end

    recommendations.each do |recommendation_hash|
      recommendation = Recommendation.new
      recommendation.team = @team
      #recommendation.question = recommendation_hash[:question][0]
      #recommendation.answers << recommendation_hash[:answers].map { |answer| answer[:answer] }
      recommendation.users << users
      recommendation.save!
    end
  end

  private

  def get_users_from_graph(graph)
    users = []
    graph.each { |edge|
      [:user_1, :user_2].each { |key| users << edge[key] }
    }

    users.uniq
  end

  def get_relevant_questions(users_graph)
    calculate_questions_similarity(users_graph).select { |_question, similarity|
      similarity >= Figaro.env.similarity_threshold.to_f
    }
  end

  def calculate_questions_similarity(users_graph)
    question_similarity = Hash.new(0)

    users_graph.each do |edge|
      get_team_questions.each do |question|
        similarity = SimilarityMachine::QuestionRelevanceCalculator.new(
          user_1: edge[:user_1],
          user_2: edge[:user_2],
          team: @team,
          question: question
        ).calculate

        question_similarity[question] += similarity if similarity
      end
    end

    question_similarity
  end

  def get_team_questions
    questions = []

    @team.exercises.each { |exercise|
      exercise.questions.map { |question| questions << question }
    }

    questions
  end
end
