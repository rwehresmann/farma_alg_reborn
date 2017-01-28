require 'utils/similarity_machine'

class ComputeUsersSimilarityJob < ApplicationJob
  queue_as :default

  def perform
    Team.active_teams.each do |team|
      compare_team_users(team)
    end
  end

    private

    def compare_team_users(team)
      users = team.users
      users.count.times do
        user_1 = users.shift
        users.each do |user_2|
          users_similarity(user_1, user_2, team)
        end
      end
    end
end
