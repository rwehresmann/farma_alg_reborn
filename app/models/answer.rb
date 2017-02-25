require 'utils/compilers'

class Answer < ApplicationRecord
  include ApplicationHelper
  include Compilers

  # The key is the difficult level, and the value is the percentage
  # of variation.
  SCORE_VARIATION = { 0 => -0.25, 1 => -0.25, 2 => -0.15, 3 => 0,
                      4 => 0.15, 5 => 0.25 }
  LIMIT_TO_START_VARIATION = 10

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
        if correct?
          score = score_to_earn
          EarnedScore.create!(user: user, question: question, team: team,
                              score: score)
        end
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

    # Based on the operation of the question answered, calculate the currently
    # score to earn.
    def score_to_earn
      if question.operation == "challenge"
        question.score
      else
        answers = Answer.by_team(team).by_question(question)
        return question.score if answers.count < LIMIT_TO_START_VARIATION
        question_level = difficult_level(answers)
        score_variation = SCORE_VARIATION[question_level]
        question.score * score_variation
      end
    end

    # Difficult level formula.
    def difficult_level(answers)
      correct = answers.where(correct: true)
      incorrect = answers.where(correct: false)
      denominator = (correct.count * 0.1 + incorrect.count * 0.2)
      normalize_difficult_level(answers.count.fdiv(denominator).ceil)
    end

    # Difficult level formula returns a number in the range 5..10. The desired
    # range is 0..5, so we normalize the result subtracting 5.
    def normalize_difficult_level(level)
      level - 5
    end
end
