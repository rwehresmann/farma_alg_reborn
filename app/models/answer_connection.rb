class AnswerConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :answer_1, class_name: :Answer
  belongs_to :answer_2, class_name: :Answer

  # Returns the answers from the connection.
  def answers
    [answer_1, answer_2]
  end

  def same_user?
    answer_1.user == answer_2.user
  end
end
