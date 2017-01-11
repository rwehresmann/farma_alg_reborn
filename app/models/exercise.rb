class Exercise < ApplicationRecord
  validates_presence_of :title, :description

  belongs_to :user
  has_many :questions
  has_and_belongs_to_many :teams
end
