class Exercise < ApplicationRecord
  validates_presence_of :title, :description

  belongs_to :user
  has_many :questions
end
