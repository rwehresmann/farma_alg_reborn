class Recommendation < ApplicationRecord
  belongs_to :team
  has_many :users
  has_many :answers
end
