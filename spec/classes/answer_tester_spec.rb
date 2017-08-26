require 'rails_helper'

describe AnswerTester do
  describe "#test" do
    it "returns a hash with the test cases results" do
      test_cases = create_pair(:test_case, :hello_world)
      question = create(:question, test_cases: test_cases)
      answer = create(:answer, question: question)

      results = described_class.new(
        answer: answer,
        file_name: SecureRandom.hex
      ).test

      expect(results.count).to eq(2)
      results.each do |result|
        expect(result.keys.count).to eq(3)
        expect(result.keys).to include(:test_case, :output, :correct)
      end
    end
  end
end
