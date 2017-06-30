module AnswerCreator
  class RankingUpdater
    def initialize(team)
      @team = team
    end

    def update_position
      general_update(:position)
    end

    def update_start_position_on_day
      general_update(:start_position_on_day)
    end

    private

    def general_update(field)
      ranking = UserScoreQuery.new.ranking(team: @team)

      ranking.each_with_index { |user_score, index|
        user_score.update_attributes(field => index + 1)
      }
    end
  end
end
