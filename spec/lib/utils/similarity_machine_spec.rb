require 'rails_helper'
require 'utils/similarity_machine'

include SimilarityMachine

describe SimilarityMachine do
  # TODO
  describe '#answers_similarity' do
    let(:answer_1) { create(:answer) }

    context "when at least one answer have compilation error" do

    end

    context "when none answer have compilation error" do

    end
  end

  # TODO: To add interesting tests here, first is necessary implement a way
  # to get only the compiler output piece from the error.
  describe '#compiler_output_similarity' do

  end

  describe '#source_code_similarity' do
    let(:similarity) { source_code_similarity(answer_1, answer_2) }
    let(:answer_1) { create(:answer) }

    context "when are very similar" do
      let(:answer_2) { create(:answer, :ola_mundo) }

      it "returns high similarity" do
        expect(similarity >= 70).to be_truthy
      end
    end

    context "when are very different" do
      let(:answer_2) { create(:answer, :params) }

      it "returns low similarity" do
        expect(similarity <= 30).to be_truthy
      end
    end
  end

  describe '#string_similarity' do
    let(:string_1) { "This is a string" }
    let(:similarity) { string_similarity(string_1, string_2) }

    context "when are very similar" do
      let(:string_2) { "I call this a string" }

      it "return high similarity" do
        expect(similarity >= 70).to be_truthy
      end
    end

    context "when are very different" do
      let(:string_2) { "I'm declaring a completely new string here" }

      it "return high similarity" do
        expect(similarity <= 30).to be_truthy
      end
    end
  end

  # TODO: Add more interesting tests here, comparing "midle scenarios".
  # To do that, is necessary whait the modification to deal with
  # defferent inputs.
  describe '#test_cases_output_similarity' do
    let(:similarity) { test_cases_output_similarity(answer_1, answer_2) }
    let(:question) { create(:question) }
    let(:answer_1) { create_right_answer_to_question(question) }

    context "when are equal" do
      let(:answer_2) { create_right_answer_to_question(question) }

      it "returns 100% similarity" do
        expect(similarity).to eq(100)
      end
    end

    context "when are completely different" do
      let(:answer_2) { create(:answer, :ola_mundo, question: question) }

      it "returns 0% similarity" do
        expect(similarity).to eq(0)
      end
    end
  end
end
