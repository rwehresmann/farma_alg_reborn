require 'utils/middlerizer'
require 'utils/incentive_ranking/ghost_user/builder'

module IncentiveRanking::GhostUser
  class Applier
    TEAM_SIZE_LIMIT_TO_START = 5

    # @target is the incentive_ranking hash data that represents the user from
    # where this incentive_ranking belongs.
    def initialize(incentive_ranking:, team:, ghost_users_number:)
      @incentive_ranking = incentive_ranking.dup
      @target = incentive_ranking.middle
      @team = team
      @ghost_users_number = ghost_users_number
    end

    def apply
      return @incentive_ranking unless need_ghost_users?

      ghost_users = IncentiveRanking::GhostUser::Builder.new(
        base_data: @target,
        team: @team
      ).build(@ghost_users_number)

      add_ghost_users(ghost_users)
    end

    private

    def add_ghost_users(ghost_users)
      new_ranking = @incentive_ranking.to_array + ghost_users
      Middlerizer.new(array: new_ranking, middle: @target)
    end

    def need_ghost_users?
      last_placed? && team_large_enought?
    end

    def last_placed?
      @incentive_ranking.upper_half.empty?
    end

    # Avoid that the incentive ranking will not have more users than the
    # amount of users in the team.
    def team_large_enought?
      @team.users.size >= (@incentive_ranking.size + @ghost_users_number)
    end
  end
end
