require 'utils/similarity_machine/utils'

module SimilarityMachine
  class UsersSimilarities
    include Utils

    attr_reader :similarities

    def initialize(team)
      @team = team
      @similarities = search
    end

    def more_similar(limit = nil)
      similarities = @similarities.select { |_user, similarity|
          similarity >= Figaro.env.similarity_threshold.to_f
      }

      limit ? similarities.first(limit) : similarities
    end

    private

    def search
      similarities = Hash.new(0)
      users = @team.users.to_a

      compare_and_shift_each(users, similarities) do |user_1, user_2|
        similarity = UserConnectionQuery.new.similarity_in_team(
          user_1: user_1,
          user_2: user_2,
          team: @team
        )

        [user_1, user_2].each { |user|
          similarities[user] += similarity
        } unless similarity.nil?
      end

      sort_similarities_desc(similarities)
    end
  end
end
