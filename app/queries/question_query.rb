class QuestionQuery
  def initialize(relation = Question.all)
    @relation = relation
  end

  def questions_answered_by_user(user, team:, limit: nil)
    @relation.joins(:answers).where(
      "answers.team_id = ? AND answers.user_id = ?", team, user
    ).distinct.limit(limit)
  end
end
