require 'utils/compilers'

class Question < ApplicationRecord
  include Compilers

  validates_presence_of :description

  belongs_to :exercise
  has_many :test_cases

  # Run the source code with the specified input of each test case and check
  # its output.
  def test_all(file_name, file_ext, source_code)
    results = []
    self.test_cases.each do |test_case|
      output = run(file_name, file_ext, source_code, test_case.input)
      if has_error? || output != test_case.output
        results << { title: test_case.title, status: :error, output: output }
      else
        results << { title: test_case.title, status: :success, output: output }
      end
    end
    results
  end
end
