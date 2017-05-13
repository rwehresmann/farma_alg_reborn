require 'utils/similarity_machine/users_calculator'

class ComputeUserSimilarityJob < ApplicationJob
  queue_as :users_similarity

  def perform
    TeamQuery.new.active_teams.each { |team| compare_team_users(team) }
  end

    private

    def compare_team_users(team)
      users = team.users.to_a
      users.count.times do
        user_1 = users.shift
        users.each do |user_2|
          similarity = SimilarityMachine::UsersCalculator.new(
            user_1: user_1,
            user_2: user_2,
            team: team
          ).calculate_similarity

          UserConnection.create!(
            user_1: user_1,
            user_2: user_2,
            similarity: similarity
          )
        end
      end
    end
end
