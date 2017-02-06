require 'utils/compilers'

class Question < ApplicationRecord
  include Compilers
  validates_presence_of :description, :score

  belongs_to :exercise
  has_many :test_cases
  has_many :answers

  # Test the source code with the specified input of each test case and check
  # its output.
  def test_all(file_name, file_ext, source_code, options = { compile: true })
    results = []
    compile(file_name, file_ext, source_code) if options[:compile]

    self.test_cases.each_with_index do |test_case, index|
      # The source code or is compiled above, or is already compiled fro where
      # 'test_all' is called, so 'compile: false'.
      test_result = test_case.test(file_name, file_ext, source_code, compile: false)
      results << { test_case: test_case, status: test_result[:status], output: test_result[:output] }
    end
    results
  end
end
