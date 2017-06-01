require 'rails_helper'

describe SimilarityMachine::TestCasesCalculator do
  describe '#calculate_similarity' do
    context "when answers have common test cases" do
      context "when test cases results are identical" do
        subject {
          described_class.new(
            *answers_with_identical_result
          ).calculate_similarity
        }

        it { is_expected.to eq 100 }
      end

      context "when test cases results are completely different" do
        subject {
          described_class.new(
            *answers_with_completely_different_results
          ).calculate_similarity
        }
        it { is_expected.to eq 0 }
      end

      context "when test cases results aren't identical neither completely different" do
        subject {
          described_class.new(
            *answers_with_similar_results
          ).calculate_similarity
        }

        it "returns a value between 0 and 100" do
          is_expected.to be < 100
          is_expected.to be > 0
        end
      end
    end

    context "when answers haven't common test cases" do
      subject {
        described_class.new(
          *answers_without_common_test_cases
        ).calculate_similarity
      }
      it { is_expected.to be_nil }
    end
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
