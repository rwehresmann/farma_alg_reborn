class AnswerTestCaseResult < ApplicationRecord
  validates_presence_of :output

  belongs_to :answer
  belongs_to :test_case
end
