class AnswerTestCaseResult < ApplicationRecord
  validates_presence_of :output
  validates_inclusion_of :correct, in: [true, false]
  validates_uniqueness_of :answer, scope: :test_case

  belongs_to :answer
  belongs_to :test_case

  # Returns the answer of an specific answer to a specific test case.
  # The 'first' result is returned, but always there must be only one result,
  # because the match 'test_case - answer' is unique.
  def self.result(answer, test_case)
    where(test_case: test_case, answer: answer).first
  end
end
