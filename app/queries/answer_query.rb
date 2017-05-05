class AnswerQuery
  def initialize(relation = Answer.all)
    @relation = relation
  end

  def user_correct_answers_from_team(user:, team:, limit: nil)
    @relation.where(user: user, team: team, correct: true).limit(limit)
  end
end
