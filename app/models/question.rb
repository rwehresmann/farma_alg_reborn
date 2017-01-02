class Question < ApplicationRecord
  validates_presence_of :description

  belongs_to :exercise
  has_many :test_cases
end
