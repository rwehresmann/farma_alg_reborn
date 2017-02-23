class AnswerConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :answer_1, class_name: :Answer
  belongs_to :answer_2, class_name: :Answer

  scope :answers_in, -> (answers = nil) do
    return unless answers.present?
    where(user_1: answers).or.where(user_2: answers)
  end

  scope :connection_threshold, -> (threshold, answers) do
    where("similarity >= ?", threshold).answers_in(answers)
  end

  # Get the similarity between two answers. This similarity is simetrical,
  # this is:
  def self.similarity(answer_1, answer_2)
    where(answer_1: answer_1, answer_2: answer_2)
    .or(where(answer_1: answer_2, answer_2: answer_1))
    .pluck(:similarity).first
  end
end
