class AnswerConnection < ApplicationRecord
  validates_presence_of :similarity

  belongs_to :answer_1, class_name: :Answer
  belongs_to :answer_2, class_name: :Answer

  # Returns the answers from the connection.
  def answers
    [answer_1, answer_2]
  end

  # Returns the connections with simmilarity bigger or equal the threshold.
  # Its possible specify the pool of answers wich one the connections should be
  # find. This option is useful, for instance, if we would like to search only
  # connections of an specific team.
  def self.by_threshold(threshold, answers = nil)
    connections(answers).where("similarity >= ?", threshold)
  end

  # Get the similarity between two answers. This similarity is simetrical:
  # answer_1 similarity with answer_2 is the same as the inverse.
  def self.similarity(answer_1, answer_2)
    where(answer_1: answer_1, answer_2: answer_2)
    .or(where(answer_1: answer_2, answer_2: answer_1))
    .pluck(:similarity).first
  end

  # type values: :with or :between.
  # It should be read as: connections WITH these answers (a "or" condition);
  # connections BETWEEN these answers (a "and" condition).
  def self.connections(answers, type = :with)
    return all if answers.nil?
    operator = type == :with ? "OR" : "AND"
    where("answer_1_id IN (?) #{operator} answer_2_id IN (?)", answers, answers)
  end

  def same_user?
    answer_1.user == answer_2.user
  end
end
