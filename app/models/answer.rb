class Answer < ApplicationRecord
  searchkick

  # The key is the difficult level, and the value is the percentage
  # of variation.
  SCORE_VARIATION = { 0 => -0.25, 1 => -0.25, 2 => -0.15, 3 => 0,
                      4 => 0.15, 5 => 0.25 }
  # Score variation starts only after a certain number of users attempts to answer.
  LIMIT_TO_START_VARIATION = 10

  before_create :set_correct
  before_validation :set_attempt
  after_create :save_test_cases_results, if: :results_present?
  after_create :increase_score, if: :increase_score?

  validates_presence_of :content, :attempt
  validates_inclusion_of :correct, in: [true, false]

  belongs_to :user
  belongs_to :question
  belongs_to :team

  # The relationship from AnswerConnection is symmetrical, and so we need
  # to check both foreign keys (answer_1 and answer_2) to discover if the
  # connection is made or not.
  has_many :answer_connections_1, class_name: "AnswerConnection", foreign_key: :answer_1_id
  has_many :answer_connections_2, class_name: "AnswerConnection", foreign_key: :answer_2_id

  has_many :test_cases_results, class_name: "AnswerTestCaseResult"
  has_many :test_cases, through: :test_cases_results
  has_many :comments

  scope :by_user, -> (user) do
    return unless user.present?
    where(user: user)
  end

  scope :by_team, -> (team) do
    return unless team.present?
    where(team: team)
  end

  scope :by_question, -> (question) do
    return unless question.present?
    where(question: question)
  end

  # 'correct' is a boolean and so the return status need to check if the value
  # is a boolean.
  scope :correct_status, -> (correct) do
    return unless [true, false].include?(correct)
    where(correct: correct)
  end

  scope :between_dates, -> (start_date, end_date) do
    return unless start_date.present? && end_date.present?
    where("created_at BETWEEN datetime(?) AND datetime(?)", start_date, end_date)
  end

  # Returns the answers which one the specified answer should be compared.
  scope :to_compare_similarity, -> (answer) do
    by_team(answer.team).by_question(answer.question).where.not(id: answer)
  end

  scope :created_last, -> do
    order(created_at: :desc)
  end

  scope :by_key_words, -> (key_words) do
    return unless key_words.present?
    search(key_words, fields: [:content])
  end

  # Returns an array of hashes, where the keys are :answer with the answer
  # object, :connection_id and :similarity with the similarity between both answers.
  def similar_answers(threshold:)
    results_1 = answers_similarity_data(answer_connections_1, threshold, :answer_2)
    results_2 = answers_similarity_data(answer_connections_2, threshold, :answer_1)
    (results_1 + results_2)
  end

  # @results is a variable who store the test case results before save the
  # answer instance. We store these results there to avoid reprocess
  # these results again, because they're used in an after create callback again.
  def results
    @results ||= []
  end

  # Send to compile and tests against all the question test cases, checking
  # if the answer is correct or not.
  def set_correct
    @results = question.test_all(file_name: SecureRandom.hex, extension: "pas",
                                 source_code: content)
    self.correct = is_correct?
  end

    private

    def increase_score?
      return true if correct? && !question.answered?(team: team, user: user,
                                                     correct_status: true)
      false
    end

    def increase_score
      score = score_to_earn
      EarnedScore.create!(user: user, question: question, team: team, score: score)
    end

    # Save the result accoring the result of each test case,
    # and enqueue the answer to compute similarities.
    def save_test_cases_results
      raise "No test case results found! Check if the question answered have at
            least one test case associated." if @results.nil?

      @results.each { |result|
        AnswerTestCaseResult.create!(answer: self, test_case: result[:test_case],
                                     output: result[:output], correct: result[:correct])
      }

      ComputeAnswerSimilarityJob.perform_later(self)
    end

    # According the results from each test case, check if the answer is correct.
    def is_correct?
      @results.each { |result| return false if result[:correct] == false }
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

    # Check if @results is defined
    def results_present?
      !@results.nil?
    end

    # Build an array of hashes, where a hash contains the answers object,
    # connection id and the similarity between both answers.
    def answers_similarity_data(connections, threshold, field_name)
      connections.where("answer_connections.similarity >= ?", threshold).map do |connection|
        { answer: connection.send(field_name), connection_id: connection.id,
          similarity: connection.similarity }
      end
    end

    # Set answer attempt number.
    def set_attempt
      attempts_count = Answer.by_question(question).by_user(user).count
      self.attempt = attempts_count + 1
    end
end
