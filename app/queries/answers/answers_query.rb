module Answers
  class AnswersQuery
    def initialize(relation = Answer.all)
      @relation = relation
    end

    def call(args = {})
      @relation.by_team(args[:teams])
        .by_user(args[:users])
        .by_question(args[:questions])
        .limit(args[:limit])
        .order(args[:order])
        .select(args[:select])
    end
  end
end
