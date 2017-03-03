class QuestionDependency < ApplicationRecord
  DEPENDENCIES = ["AND", "OR"]

  belongs_to :question_1, class_name: :Question
  belongs_to :question_2, class_name: :Question

  validates_inclusion_of :operator, in: DEPENDENCIES
  validate :belongs_to_same_exercise

    private

    def belongs_to_same_exercise
      errors.add("Cannot create dependencies between questions in different exercises.") if question_1.exercise != question_2.exercise
    end
end
