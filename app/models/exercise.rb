class Exercise < ApplicationRecord
  validates_presence_of :title, :description

  belongs_to :learning_object
end
