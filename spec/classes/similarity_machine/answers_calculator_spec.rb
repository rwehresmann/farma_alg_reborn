require 'rails_helper'

describe SimilarityMachine::AnswersCalculator do
  describe '#calculate_similarity' do
    context "when answers haven't common test cases" do
      context "when answers are identical" do
        subject { call_mocking(build_pair(:answer, :hello_world), 100) }

        it { is_expected.to eq 100 }
      end

      context "when answers are completely different" do
        subject { call_mocking(completely_different_answers, 0) }

        it { is_expected.to eq 0  }
      end

      context "when answers aren't identical neither completely different" do
        subject { call_mocking(similar_answers, 80) }

        it { is_expected.to eq 80  }
      end
    end

    context "when answers have common test cases" do
      subject { call_mocking(answers_with_similar_results, 100) }

      it "is a number resulted from the answers similarity formula" do
        is_expected.to be_a_kind_of Numeric
        is_expected.to_not eq(100)
      end
    end
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

  def completely_different_answers
    [build(:answer, :hello_world), build(:answer, :params)]
  end

  def similar_answers
    [build(:answer, :hello_world), build(:answer, :hello_world_2)]
  end

  def call_mocking(answers, return_value)
    calculator = described_class.new(*answers)
    allow_any_instance_of(MossMatcher).to receive(:call).with(no_args) { return_value }
    calculator.calculate_similarity
  end
end
