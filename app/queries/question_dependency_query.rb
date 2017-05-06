class QuestionDependencyQuery
  def initialize(relation = QuestionDependency.all)
    @relation = relation
  end

  def dependency_operator(question_1:, question_2:)
    @relation.select(:operator)
      .where(question_1: question_1, question_2: question_2)
  end

  def dependencies_by_operator(operator)
    @relation.where(operator: operator)
  end
end
