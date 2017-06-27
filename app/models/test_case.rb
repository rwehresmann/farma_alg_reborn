require 'utils/code_runner'

class TestCase < ApplicationRecord
  validates_presence_of :output, :title

  belongs_to :question

  serialize :input, Array

  # Test a the compiled source code whit the test case (when 'compiled: false',
  # the source code must have been compiled already).
  def test(file_name:, extension:, source_code:, not_compile: false)
    code_runner = CodeRunner.new(file_name: file_name, extension: extension,
                                 source_code: source_code)
    result = code_runner.run(inputs: inputs, not_compile: not_compile)
    output = self.output.gsub("\r", "")

    { output: result, correct: result == output  }
  end
end
