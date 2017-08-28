class Answer < ApplicationRecord
  searchkick

  validates_presence_of :content, :attempt, :lang_extension
  validates_inclusion_of :correct, in: [true, false]

  belongs_to :user
  belongs_to :question
  belongs_to :team

  # The relationship from AnswerConnection is symmetrical, and so we need
  # to check both foreign keys (answer_1 and answer_2) to discover if the
  # connection is made or not.
  has_many :answer_connections_1, class_name: "AnswerConnection", foreign_key: :answer_1_id, dependent: :destroy
  has_many :answer_connections_2, class_name: "AnswerConnection", foreign_key: :answer_2_id, dependent: :destroy

  has_many :test_cases_results, class_name: "AnswerTestCaseResult", dependent: :destroy
  has_many :test_cases, through: :test_cases_results

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
    where("created_at BETWEEN ? AND ?", start_date, end_date)
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

  # Get similarity between two users, if already calculated.
  def similarity_with(answer)
    query_result = AnswerConnectionQuery.new.get_similarity(self, answer).first
    if query_result then query_result.similarity else nil end
  end

  private

  # Build an array of hashes, where a hash contains the answers object,
  # connection id and the similarity between both answers.
  def answers_similarity_data(connections, threshold, field_name)
    AnswerConnectionQuery.new(connections)
      .connections_by_threshold(min: threshold).map { |connection|
        { answer: connection.send(field_name), connection_id: connection.id,
          similarity: connection.similarity }
      }
  end
end
