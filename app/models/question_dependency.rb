class QuestionDependency < ApplicationRecord
  DEPENDENCIES = ["AND", "OR"]

  belongs_to :question_1, class_name: :Question
  belongs_to :question_2, class_name: :Question

  validates_inclusion_of :operator, in: DEPENDENCIES
  validate :belongs_to_same_exercise

  scope :with_question_1, -> (question) do
    return unless question.present?
    where(question_1: question)
  end

  scope :with_question_2, -> (question) do
    return unless question.present?
    where(question_2: question)
  end

  scope :by_operator, -> (operator) do
    return unless operator.present?
    where(operator: operator)
  end

    private

    def belongs_to_same_exercise
      errors.add("Cannot create dependencies between questions in different exercises.") if question_1.exercise != question_2.exercise
    end
end
