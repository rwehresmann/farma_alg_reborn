class AnswerConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :answer_1, class_name: :Answer
  belongs_to :answer_2, class_name: :Answer

  # Shortcut to get the resulted similarity between two answers.
  def self.similarity(answer_1, answer_2)
    where(answer_1: answer_1, answer_2: answer_2).or(where(answer_1: answer_2, answer_2: answer_1)).pluck(:similarity).first
  end

  # answer_1 similarity to answer_2 means the same similarity of answer_2
  # to answer_1.
  def self.create_simetrical_record(answer_1, answer_2, similarity)
    AnswerConnection.create!(answer_1: answer_1, answer_2: answer_2, similarity: similarity)
    AnswerConnection.create!(answer_1: answer_2, answer_2: answer_1, similarity: similarity)
  end
end
