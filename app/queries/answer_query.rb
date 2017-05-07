class AnswerQuery
  def initialize(relation = Answer.all)
    @relation = relation.extending(Scopes)
  end

  def user_answers(user, to: {}, limit: nil)
    @relation.where(user: user)
    .by_team(to[:team])
    .by_question(to[:question])
    .limit(limit)
  end

  def user_correct_answers(user, to: {}, limit: nil)
    @relation.where(user: user, correct: true)
    .by_team(to[:team])
    .by_question(to[:question])
    .limit(limit)
  end

  def user_last_correct_answer(user, to: {})
    user_correct_answers(user, to: to, limit: 1).order(created_at: :desc)
  end

  def team_answers(team, options = {})
    @relation.where(team: team)
      .by_question(options[:question]).limit(options[:limit])
  end

  def team_correct_answers(team, options = {})
    @relation.where(team: team, correct: true)
    .by_question(options[:question])
    .limit(options[:limit])
  end

  private

  module Scopes
    def by_correct_status(correct = nil)
      return all unless correct.present?
      where(correct: correct)
    end

    def by_team(team = nil)
      return all unless team.present?
      where(team: team)
    end

    def by_question(question = nil)
      return all unless question.present?
      where(question: question)
    end
  end
end
