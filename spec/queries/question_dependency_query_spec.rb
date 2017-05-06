require 'rails_helper'

describe QuestionDependencyQuery do
  describe '#dependency_operator' do
    let(:exercise) { create(:exercise) }
    let(:questions) { create_pair(:question, exercise: exercise) }
    let!(:question_dependency) {
      create(:question_dependency, question_1: questions[0],
        question_2: questions[1], operator: "OR")
    }

    subject { described_class.new.dependency_operator(
      question_1: questions[0], question_2: questions[1]).first.operator
    }

    it { expect(subject).to eq(question_dependency.operator) }
  end

  describe '#dependencies_by_operator' do
    let(:exercise) { create(:exercise) }
    let(:questions) { create_list(:question, 4, exercise: exercise) }
    let!(:dependency_1) {
      create(:question_dependency, question_1: questions[0],
        question_2: questions[1], operator: "AND")
    }
    let!(:dependency_2) {
      create(:question_dependency, question_1: questions[0],
        question_2: questions[2], operator: "OR")
    }
    let!(:dependency_3) {
      create(:question_dependency, question_1: questions[0],
        question_2: questions[3], operator: "AND")
    }

    subject { described_class.new.dependencies_by_operator(operator) }

    context "when should only bring dependencies 'AND'" do
      let(:operator) { "AND" }

      it { expect(subject).to eq([dependency_1, dependency_3]) }
    end

    context "when should only bring dependencies 'OR'" do
      let(:operator) { "OR" }

      it { expect(subject).to eq([dependency_2]) }
    end
  end
end
