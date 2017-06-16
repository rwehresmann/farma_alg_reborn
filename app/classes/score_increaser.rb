class ScoreIncreaser
  # The key is the difficult level, and the value is the percentage
  # of variation.
  SCORE_VARIATION = {
    0 => -0.25,
    1 => -0.25,
    2 => -0.15,
    3 => 0,
    4 => 0.15,
    5 => 0.25
  }

  # Score variation starts only after a certain number of users attempts to answer.
  LIMIT_TO_START_VARIATION = 10

  def initialize(user:, team:, question:)
    @user = user
    @team = team
    @question = question
  end

  def increase
    EarnedScore.create!(
      user: @user,
      question: @question,
      team: @team,
      score: calculate_score_to_earn
    )
  end

  private

  def calculate_score_to_earn
    return @question.score if  @question.operation == "challenge"

    answers = AnswerQuery.new.team_answers(@team, question: @question)
    return @question.score if answers.count < LIMIT_TO_START_VARIATION

    question_level = difficult_level(answers)
    score_variation = SCORE_VARIATION[question_level]

    @question.score * score_variation
  end

  # Difficult level formula.
  def difficult_level(answers)
    correct = answers.where(correct: true)
    incorrect = answers.where(correct: false)
    denominator = (correct.count * 0.1 + incorrect.count * 0.2)
    normalize_difficult_level(answers.count.fdiv(denominator).ceil)
  end

  # Difficult level formula returns a number in the range 5..10. The desired
  # range is 0..5, so we normalize the result subtracting 5.
  def normalize_difficult_level(level)
    level - 5
  end
end
