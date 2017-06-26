class Recommendation < ApplicationRecord
  belongs_to :team
  belongs_to :question
  has_many :users
  has_many :answers
end
