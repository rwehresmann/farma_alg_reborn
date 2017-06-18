module SimilarityMachine
  class UsersGraphGenerator
    include Utils

    def initialize(team)
      @team = team
    end

    def generate
      graph = []
      users = @team.users.to_a

      compare_and_shift_each(users, graph) do |user_1, user_2|
        similarity = UserConnectionQuery.new.similarity_in_team(
          user_1: user_1,
          user_2: user_2,
          team: @team
        )

        unless similarity.nil?
          connection = { user_1: user_1, user_2: user_2, similarity: similarity }
          graph << connection
        end

        graph
      end

      more_similar(graph)
    end

    def more_similar(graph)
      graph.select { |connection|
        connection[:similarity] >= Figaro.env.similarity_threshold.to_f
      }
    end
  end
end
