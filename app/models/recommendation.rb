class Recommendation < ApplicationRecord
  belongs_to :team
  belongs_to :question
end
