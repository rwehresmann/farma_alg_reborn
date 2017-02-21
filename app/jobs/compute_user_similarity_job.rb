require 'utils/similarity_machine'

class ComputeUserSimilarityJob < ApplicationJob
  include SimilarityMachine

  queue_as :default

  def perform
    Team.active_teams.each do |team|
      compare_team_users(team)
    end
  end

    private

    def compare_team_users(team)
      users = team.users.to_a
      users.count.times do
        user_1 = users.shift
        users.each do |user_2|
          similarity = users_similarity(user_1, user_2, team)
          UserConnection.create_simetrical_record(user_1, user_2, similarity)
        end
      end
    end
end
