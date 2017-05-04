class UserScore < ApplicationRecord
  validates_presence_of :score

  belongs_to :user
  belongs_to :team
end
