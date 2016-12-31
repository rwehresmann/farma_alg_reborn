class Answer < ApplicationRecord
  validates_presence_of :content
  validates_inclusion_of :correct, in: [true, false]

  belongs_to :user
  belongs_to :question
end
