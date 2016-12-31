class Question < ApplicationRecord
  validates_presence_of :description

  belongs_to :exercise
end
