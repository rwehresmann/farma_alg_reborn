require 'utils/middlerizer'

module IncentiveRanking
  class Builder
    def initialize(target:, team:, answers_number: 5, positions: {})
      @target = target
      @team = team
      @positions = positions
      @answers_number = answers_number
    end

    def build
      ranking = splited_ranking
      ranking[:upper_half] = ranking[:upper_half].first(@positions[:above])
      ranking[:lower_half] = ranking[:lower_half].first(@positions[:below])
      formated_ranking = format_ranking(ranking)
      join_ranking_with_answers(formated_ranking)
    end

    private

    def format_ranking(middlerized_ranking)
      upper_half = middlerized_ranking[:upper_half].map { |user_score|
        { user: user_score.user, score: user_score.score }
      }

      middle = [ { user: @target.user, score: @target.score } ]

      lower_half = middlerized_ranking[:lower_half].map { |user_score|
        { user: user_score.user, score: user_score.score }
      }

      lower_half + middle + upper_half
    end

    def join_ranking_with_answers(formated_ranking)
      formated_ranking.map do |user_score|
        user_score.merge(
          answers: Answer.by_user(user_score[:user])
          .by_team(@team).limit(@answers_number)
        )
      end
    end

    def splited_ranking
      Middlerizer.new(
        target_object: @target,
        array: UserScore.rank(team: @team)
      ).middlerized
    end
  end
end
