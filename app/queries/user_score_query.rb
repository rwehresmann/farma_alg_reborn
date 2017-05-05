class UserScoreQuery
  def initialize(relation = UserScore.all)
    @relation = relation.extending(Scopes)
  end

  def ranking(args = {})
    @relation.by_user(args[:user])
      .by_team(args[:team])
      .top(args[:limit])
  end

  module Scopes
    def by_user(user = nil)
      return all unless user.present?
      where(user: user)
    end

    def by_team(team = nil)
      return all unless team.present?
      where(team: team)
    end

    def top(limit = nil)
      order(score: :desc).limit(limit)
    end
  end
end
