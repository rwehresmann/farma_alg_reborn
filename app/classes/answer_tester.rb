class AnswerTester
  def initialize(answer:, file_name:)
    @answer = answer
    @file_name = file_name
  end

  def test
    code_runner = CodeRunner.new(
      file_name: @file_name,
      extension: @answer.lang_extension,
      source_code: @answer.content
    )

    code_runner.compile

    @answer.question.test_cases.each.inject([]) do |results, test_case|
      result = code_runner.run(inputs: test_case.inputs, not_compile: true)

      results << {
        test_case: test_case,
        correct: result == test_case.output,
        output: result.gsub("\r", "")
      }
    end
  end
end
