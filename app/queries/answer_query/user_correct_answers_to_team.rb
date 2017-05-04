module AnswerQuery
  class UserCorrectAnswersToTeam
    def initialize(relation = Answer.all)
      @relation = relation
    end

    def call(user:, team:, limit: nil)
      @relation.where(user: user, team: team, correct: true).limit(limit)
    end
  end
end
