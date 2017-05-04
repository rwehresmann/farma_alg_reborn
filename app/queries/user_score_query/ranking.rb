module UserScoreQuery
  class Ranking
    extend Scopes

    def initialize(relation = UserScore.all)
      @relation = relation
    end

    def call(args = [])
      @relation.by_user(args[:user])
        .by_team(args[:team])
        .top(args[:limit])
    end
  end
end
