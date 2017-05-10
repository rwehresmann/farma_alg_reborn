require 'rails_helper'
require './lib/utils/similarity_machine/answers/test_cases_calculator'

describe SimilarityMachine::Answers::TestCasesCalculator do
  describe '#calculate' do
    context "when answers have common test cases" do
      context "when test cases results are identical" do
        subject { call_calculator(*answers_with_identical_result) }

        it { is_expected.to eq 100 }
      end

      context "when test cases results are completely different" do
        subject { call_calculator(*answers_with_completely_different_results) }

        it { is_expected.to eq 0 }
      end

      context "when test cases results aren't identical neither completely different" do
        subject { call_calculator(*answers_with_similar_results) }

        it "returns a value between 0 and 100" do
          is_expected.to be < 100
          is_expected.to be > 0
        end
      end
    end

    context "when answers haven't common test cases" do
      subject { call_calculator(*answers_without_common_test_cases) }

      it { is_expected.to be_nil }
    end
  end

  def call_calculator(answer_1, answer_2)
    object = Object.new.extend(described_class)
    object.instance_variable_set(:@answer_1, answer_1)
    object.instance_variable_set(:@answer_2, answer_2)
    object.test_cases_similarity
  end

  def answers_with_identical_result
    answers = create_pair(:answer)
    common_tc = create(:test_case)

    answers.each  { |answer|
      create(
        :answer_test_case_result,
        answer: answer,
        test_case: common_tc,
        output: "Hello world"
      )
    }

    answers
  end

  def answers_with_completely_different_results
    answers = create_pair(:answer)
    common_tc = create(:test_case)

    create(
      :answer_test_case_result,
      answer: answers[0],
      test_case: common_tc,
      output: "Hello world"
    )

    create(
      :answer_test_case_result,
      answer: answers[1],
      test_case: common_tc,
      output: "Another output"
    )

    answers
  end

  def answers_with_similar_results
    answers = create_pair(:answer)
    common_tc = create(:test_case)

    create(
      :answer_test_case_result,
      answer: answers[0],
      test_case: common_tc,
      output: "Hello world"
    )

    create(
      :answer_test_case_result,
      answer: answers[1],
      test_case: common_tc,
      output: "Hello from another world"
    )

    answers
  end

  def answers_without_common_test_cases
    answers = create_pair(:answer)
    test_cases = create_pair(:test_case)

    answers.each_with_index { |answer, index|
      create(
        :answer_test_case_result,
        answer: answer,
        test_case: test_cases[index],
        output: "Hello world"
      )
    }

    answers
  end
end
