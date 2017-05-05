class AnswerQuery
  def initialize(relation = Answer.all)
    @relation = relation
  end

  def user_correct_answers_from_team(user:, team:, limit: nil)
    @relation.where(user: user, team: team, correct: true).limit(limit)
  end

  def user_last_correct_answer_from_team(user:, team:, question:)
    @relation.where(
      user: user, team: team, question: question, correct: true
    ).limit(1)
  end
end
