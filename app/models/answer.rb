require 'utils/compilers'

class Answer < ApplicationRecord
  include ApplicationHelper
  include Compilers

  attr_reader :results

  before_create :check_answer
  after_create :save_results

  validates_presence_of :content
  validates_inclusion_of :correct, in: [true, false]

  belongs_to :user
  belongs_to :question
  belongs_to :team
  has_many :answer_connections, foreign_key: :answer_1_id
  has_many :similarities, through: :answer_connections, source: :answer_2
  has_many :test_cases_results, class_name: "AnswerTestCaseResult"
  has_many :test_cases, through: :test_cases_results

  scope :by_user, -> (user = nil) do
    return unless user.present?
    where(user: user)
  end

  scope :by_team, -> (team = nil) do
    return unless team.present?
    where(team: team)
  end

  scope :by_question, -> (question = nil) do
    return unless question.present?
    where(question: question)
  end

  # Return the answers which the specified answer should be compared.
  scope :to_compare_similarity, -> (answer) do
    by_team(answer.team).by_question(answer.question).where.not(id: answer)
  end

    private

    # Compile the source code, set compiler_output and compilation_erro flag,
    # and run the test cases if the answer is compiled succesfully to check if
    # is right or wrong. We use @results because after the answer is saved,
    # after create callback call a new method and use the same results.
    def check_answer
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
        score = question.task? ? question.registered_score : question.mutable_score
        EarnedScore.create!(user: user, question: question, team: team,
                            score: score) if correct?
      end
    end

    # Save the result accoring the result of each test case (@results is filled
    # from set_correct method), and enqueue the answer to compute similarities.
    def save_results
      @results.each do |result|
        AnswerTestCaseResult.create!(answer: self,
                                     test_case: result[:test_case],
                                     output: result[:output])
      end

      ComputeAnswerSimilarityJob.perform_later(self)
    end

    # According the results from each test case, check if the answer is correct.
    def is_correct?(results)
      results.each { |result| return false if result[:status] == :error }
      true
    end
end
