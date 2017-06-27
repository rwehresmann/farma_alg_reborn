require 'utils/code_runner'

class TestCase < ApplicationRecord
  validates_presence_of :output, :title

  belongs_to :question

  serialize :input, Array

  before_save :remove_returns_from_output
  before_update :remove_returns_from_output

  private

  def remove_returns_from_output
    self.output.gsub!("\r","")
  end
end
