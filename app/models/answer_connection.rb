class AnswerConnection < ApplicationRecord
  validates_presence_of :similarity
  
  belongs_to :answer_1, class_name: :Answer
  belongs_to :answer_2, class_name: :Answer
end
