require 'utils/compilers'

class TestCase < ApplicationRecord
  include Compilers
  validates_presence_of :output, :title

  belongs_to :question

  # Test a the compiled source code whit the test case (when 'compiled: false',
  # the source code must have been compiled already).
  def test(file_name, file_ext, source_code, options = { compile: true })
    if options[:compile] == true
      result = compile_and_run(file_name, file_ext, source_code, input)
    else
      result = run(file_name, file_ext, source_code, input)
    end
    output = self.output.gsub("\r", "")

    if result != output
      { status: :error, output: result }
    else
      { status: :success, output: result }
    end
  end
end
