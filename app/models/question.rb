require 'utils/compilers'

class Question < ApplicationRecord
  include Compilers

  validates_presence_of :description

  belongs_to :exercise
  has_many :test_cases
  has_many :answers

  # Run the source code with the specified input of each test case and check
  # its output.
  def test_all(file_name, file_ext, source_code)
    results = []
    self.test_cases.each_with_index do |test_case, index|
      # 'file_name' must be composed by the index to avoid that 'run' method
      # doesn't write the compiler output in the same file.
      output = run("#{file_name}_#{index}", file_ext, source_code, test_case.input)
      if has_error? || output != test_case.output
        results << { title: test_case.title, status: :error, output: output }
      else
        results << { title: test_case.title, status: :success, output: output }
      end
    end
    results
  end
end
