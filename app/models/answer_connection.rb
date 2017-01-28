class AnswerConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :answer_1, class_name: :Answer
  belongs_to :answer_2, class_name: :Answer

  # Shortcut to get the resulted similarity between two answers
  def self.similarity(answer_a, answer_b)
    where(answer_1: answer_a, answer_2: answer_b).or(where(answer_1: answer_b, answer_2: answer_a)).pluck(:similarity).first
  end
end
