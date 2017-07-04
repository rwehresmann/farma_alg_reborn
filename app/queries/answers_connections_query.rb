class AnswersConnectionsQuery
  def initialize(answers)
    @answers = answers
  end

  def call
    AnswerConnection.where(answer_1: @answers)
      .or(AnswerConnection.where(answer_2: @answers))
  end
end
