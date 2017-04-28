module QuestionDependencies
  class DependenciesQuery
    def initialize(relation = QuestionDependency)
      @relation = relation
    end

    def call(args = {})
      @relation.select(args[:select])
        .with_question_1(args[:question_1])
        .with_question_2(args[:question_2])
        .by_operator(args[:operator])
    end
  end
end
