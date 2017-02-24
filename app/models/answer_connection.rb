class AnswerConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :answer_1, class_name: :Answer
  belongs_to :answer_2, class_name: :Answer

  # Returns the answers from the connection.
  def answers
    [answer_1, answer_2]
  end

  # Returns the connection bigger or equal the threshold.
  def self.by_threshold(threshold, answers = nil)
    where("similarity >= ?", threshold).answers_in(answers)
  end

  # Get the similarity between two answers. This similarity is simetrical:
  # answer_1 similarity with answer_2 is the same as the inverse.
  def self.similarity(answer_1, answer_2)
    where(answer_1: answer_1, answer_2: answer_2)
    .or(where(answer_1: answer_2, answer_2: answer_1))
    .pluck(:similarity).first
  end

    private

    # Used in connection_threshold, specify the answers to be checked. The double
    # 'where' is necessary because the answers simmetrycal relationship.
    def self.answers_in(answers = nil)
      return all unless answers.present?
      where(answer_1: answers).where(answer_2: answers)
    end
end
