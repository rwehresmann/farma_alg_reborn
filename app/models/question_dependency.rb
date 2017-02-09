class QuestionDependency < ApplicationRecord
  DEPENDENCIES = ["AND", "OR"]

  belongs_to :question_1, class_name: :Question, dependent: :destroy
  belongs_to :question_2, class_name: :Question, dependent: :destroy

  validates_inclusion_of :operator, in: DEPENDENCIES
  validate :belongs_to_same_exercise

  # If question_2 is dependent of question_1, question_1 is dependent of
  # question_2.
  def self.create_symmetrical_record(question_1, question_2, operator)
    QuestionDependency.create!(question_1: question_1, question_2: question_2,
                               operator: operator)
    QuestionDependency.create!(question_1: question_2, question_2: question_1,
                               operator: operator)
  end

  def destroy_symmetrical_record
    QuestionDependency.where(question_1: question_2, question_2: question_1).first.destroy
    self.destroy
  end

    private

    def belongs_to_same_exercise
      errors.add("Cannot create dependencies between questions in different exercises.") if question_1.exercise != question_2.exercise
    end
end
