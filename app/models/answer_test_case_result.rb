class AnswerTestCaseResult < ApplicationRecord
  validates_presence_of :output

  belongs_to :answer
  belongs_to :test_case

  def self.result(answer, test_case)
    where(test_case: test_case, answer: answer)
  end
end
