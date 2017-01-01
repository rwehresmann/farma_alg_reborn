class Exercise < ApplicationRecord
  validates_presence_of :title, :description

  has_and_belongs_to_many :learning_object
end
