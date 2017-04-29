require 'utils/code_runner'

class Question < ApplicationRecord
  before_destroy :destroy_dependencies
  before_create :normalize_operation

  validates_presence_of :title, :description, :score
  validates_inclusion_of :operation, in: ["challenge", "task"]

  belongs_to :exercise
  has_many :test_cases
  has_many :answers
  has_many :question_dependencies, foreign_key: :question_1_id
  has_many :dependencies, through: :question_dependencies, source: :question_2

  # Test the source code with the specified input of each test case and check
  # its output.
  def test_all(file_name:, extension:, source_code:, not_compile: false)
    code_runner = CodeRunner.new(file_name: file_name, extension: extension,
                                 source_code: source_code)
    code_runner.compile unless not_compile

    self.test_cases.each.inject([]) do |results, test_case|
      test_result = test_case.test(file_name: file_name, extension: extension,
                                   source_code: source_code, not_compile: true)
      results << { test_case: test_case, correct: test_result[:correct],
                   output: test_result[:output] }
    end
  end

  # Check what is the dependency operator between two questions.
  def dependency_with(question)
    QuestionDependencies::DependenciesQuery.new.call(
      select: :operator,
      question_1: self,
      question_2: question
    ).first.operator
  end

  def task?
    operation == "task"
  end

  def answered?(args = {})
    !Answers::AnswersQuery.new.call(
      select: 1,
      questions: self,
      users: args[:users],
      teams: args[:teams],
      correct: args[:correct],
      limit: 1
    ).empty?
  end

  # Select dependencies according the informed operator.
  def dependencies_of_operator(operator)
    QuestionDependencies::DependenciesQuery.new(question_dependencies).call(
      select: :question_2_id,
      operator: operator
    ).map(&:question_2)
  end

  def last_correct_answer(team, user)
    Answers::AnswersQuery.new.call(
      questions: self,
      teams: team,
      users: user,
      correct: true,
      order: { created_at: :desc },
      limit: 1
    ).first
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
