require 'utils/compilers'

class Answer < ApplicationRecord
  include ApplicationHelper
  include Compilers
  attr_reader :results

  before_create :set_correct
  # If compilator points error in source code, there is no need to
  # test with the question test cases.
  after_create :save_test_cases_result

  validates_presence_of :content
  validates_inclusion_of :correct, in: [true, false]

  belongs_to :user
  belongs_to :question
  belongs_to :team
  has_many :answer_connections, foreign_key: :answer_1_id
  has_many :similarities, through: :answer_connections, source: :answer_2
  has_many :test_cases_results, class_name: "AnswerTestCaseResult"
  has_many :test_cases, through: :test_cases_results

  def self.all_team_answers_to_question(team, question, options = {})
    query = "team_id = ? AND question_id = ? "
    return Answer.where(query.concat("AND id NOT IN (?)"), team, question, options[:except]) if options[:except]
    Answer.where(query, team, question)
  end

    private

    # Compile the source code, set compiler_output and compilation_erro flag,
    # and run the test cases if the answer is compiled succesfully to check if
    # is right or wrong. We use @results because after the answer is saved,
    # after create callback call a new method and use the same results.
    def set_correct
      filename = plain_current_datetime
      self.compiler_output = compile(filename, "pas", content)

      if has_error?
        self.compilation_error = true
        self.correct = false
        @results = []
      else
        self.compilation_error = false
        # The source code is already compiled, so 'compile: false'.
        @results = question.test_all(filename, "pas", content, compile: false)
        self.correct = is_correct?(@results)
      end
    end

    # Save the result accoring the result of each test case (@results is filled
    # from set_correct method).
    def save_test_cases_result
      ComputeSimilarityJob.perform_later(self)

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
