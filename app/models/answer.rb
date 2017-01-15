class Answer < ApplicationRecord
  include ApplicationHelper

  attr_reader :results

  before_create :set_correct
  after_create :save_test_cases_result

  validates_presence_of :content
  validates_inclusion_of :correct, in: [true, false]

  belongs_to :user
  belongs_to :question
  has_many :test_cases_results, class_name: "AnswerTestCaseResult"

    private

    # Compile the source code and run the test cases to check if the answer
    # is right or wrong. We use @results because after the answer is saved,
    # after create callback call a new method and use the same results.
    def set_correct
      @results = question.test_all(plain_current_datetime, "pas", content)
      self.correct = is_correct?(@results)
    end

    # Save the result accoring the result of each test case (@results is filled
    # from set_correct method).
    def save_test_cases_result
      @results.each do |result|
        AnswerTestCaseResult.create!(answer: self,
                                     test_case: result[:test_case],
                                     output: result[:output])
      end
    end

    # According the results from each test case, check if the answer is correct.
    def is_correct?(results)
      results.each { |result| return false if result[:status] == :error }
      true
    end
end
