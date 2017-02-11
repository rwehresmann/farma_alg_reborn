require 'utils/compilers'

class Question < ApplicationRecord
  include Compilers

  before_destroy :destroy_dependencies

  validates_presence_of :description, :score

  belongs_to :exercise
  has_many :test_cases
  has_many :answers
  has_many :question_dependencies, foreign_key: :question_1_id
  has_many :dependencies, through: :question_dependencies, source: :question_2

  # Test the source code with the specified input of each test case and check
  # its output.
  def test_all(file_name, file_ext, source_code, options = { compile: true })
    results = []
    compile(file_name, file_ext, source_code) if options[:compile]

    self.test_cases.each_with_index do |test_case, index|
      # The source code or is compiled above, or is already compiled fro where
      # 'test_all' is called, so 'compile: false'.
      test_result = test_case.test(file_name, file_ext, source_code, compile: false)
      results << { test_case: test_case, status: test_result[:status], output: test_result[:output] }
    end
    results
  end

  def dependency_with(question)
    QuestionDependency.where(question_1: self, question_2: question).pluck(:operator).first
  end

    private

    # Destroy all dependencies (the symmetrical pair).
    def destroy_dependencies
      question_dependencies.each { |dep| dep.destroy_symmetrical_record }
    end
end
