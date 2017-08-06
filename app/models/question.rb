require 'utils/code_runner'

class Question < ApplicationRecord
  before_destroy :destroy_dependencies
  before_create :normalize_operation

  validates_presence_of :title, :description, :score
  validates_inclusion_of :operation, in: ["challenge", "task"]

  belongs_to :exercise
  has_many :test_cases, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :question_dependencies, foreign_key: :question_1_id, dependent: :destroy
  has_many :dependencies, through: :question_dependencies, source: :question_2


  # Check what is the dependency operator between two questions.
  def dependency_with(question)
    QuestionDependencyQuery.new.dependency_operator(
      question_1: self, question_2: question).first.operator
  end

  def task?
    operation == "task"
  end

  def answered_by_user?(user, team:, only_correct: false)
    query_method = only_correct ? :user_correct_answers : :user_answers
    !AnswerQuery.new.send(
      query_method, user, to: { team: team, question: self }, limit: 1
    ).empty?
  end

  # Select dependencies according the informed operator.
  def dependencies_of_operator(operator)
    QuestionDependencyQuery.new(question_dependencies)
      .dependencies_by_operator(operator).map(&:question_2)
  end

    private

    # Destroy all dependencies (the symmetrical pair).
    def destroy_dependencies
      question_dependencies.each { |dep| dep.destroy }
    end

    def normalize_operation
      self.operation.downcase!
    end
end
