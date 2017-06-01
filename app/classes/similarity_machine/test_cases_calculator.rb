module SimilarityMachine
  class TestCasesCalculator
    include Amatch

    def initialize(answer_1, answer_2)
      @answer_1 = answer_1
      @answer_2 = answer_2
    end

    def calculate_similarity
      similarities = common_test_cases.each.inject([]) do |array, test_case|
        result_1 = AnswerTestCaseResult.result(@answer_1, test_case).output
        result_2 = AnswerTestCaseResult.result(@answer_2, test_case).output
        array << string_similarity(result_1, result_2)
      end

      return if similarities.empty?
      similarities.avg
    end

    private

    def common_test_cases
      test_cases_1 = @answer_1.test_cases.to_a
      test_cases_2 = @answer_2.test_cases.to_a
      test_cases_1.common_values(test_cases_2.to_a)
    end

    def string_similarity(string_1, string_2)
      to_match = PairDistance.new(string_1)
      to_match.match(string_2) * 100
    end
  end
end
