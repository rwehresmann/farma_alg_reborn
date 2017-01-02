class TestCase < ApplicationRecord
  validates_presence_of :input, :output

  belongs_to :question
end
