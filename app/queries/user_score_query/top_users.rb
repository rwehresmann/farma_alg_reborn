module UserScoreQuery
  class TopUsers
    def initialize(relation = UserScore.all)
      @relation = relation
    end

    def call(limit = nil)
      @relation.order(score: :desc).limit(limit)
    end
  end
end
