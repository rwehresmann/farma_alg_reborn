class EarnedScore < ApplicationRecord
  validates_presence_of :score

  belongs_to :user
  belongs_to :question
  belongs_to :team
end
