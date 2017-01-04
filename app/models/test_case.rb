require 'utils/compilers'

class TestCase < ApplicationRecord
  include Compilers
  validates_presence_of :output, :title

  belongs_to :question

  def test(file_name, file_ext, source_code)
    result = run(file_name, file_ext, source_code, input)
    output = self.output.gsub("\r", "")

    if has_error?
      { error: result }
    elsif result == output
      { success: result }
    else
      { failure: result }
    end
  end
end
