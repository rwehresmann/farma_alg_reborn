require 'utils/similarity_machine/answers/test_cases_calculator'

module SimilarityMachine
  module Answers

    class Calculator
      include Amatch
      include TestCasesCalculator

      attr_reader :answer_1
      attr_reader :answer_2

      def initialize(answer_1, answer_2)
        @answer_1 = answer_1
        @answer_2 = answer_2
      end

      def calculate
        test_cases_sim = test_cases_similarity
        return (0.4 * source_code_similarity + 0.6 * test_cases_sim) if test_cases_sim
        source_code_similarity
      end

      private

      def source_code_similarity
        source_codes = [@answer_1.content, @answer_2.content]
        MossMatcher.new(source_codes: source_codes).call
      end
    end

  end
end
