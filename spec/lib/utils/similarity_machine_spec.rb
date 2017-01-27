require 'rails_helper'
require 'utils/similarity_machine'

include SimilarityMachine

describe SimilarityMachine do

  describe '#answers_similarity' do
    let(:test_obj) { Object.new }

    subject do
      test_obj.extend(SimilarityMachine)
      test_obj.answers_similarity(answer_1, answer_2)
    end

    context "when both answers have compilation error" do
      let(:answer_1) { create(:answer, :whit_compilation_error) }
      let(:answer_2) { create(:answer, :whit_compilation_error) }

      it "calls compiler_output_similarity method" do
        expect(test_obj).to receive(:compiler_output_similarity)
        subject
      end
    end

    context "when at least one answer have compilation error" do
      let(:answer_1) { create(:answer) }
      let(:answer_2) { create(:answer, :whit_compilation_error) }

      it "calls source_code_similarity method" do
        expect(test_obj).to receive(:source_code_similarity)
        subject
      end
    end

    context "when none answer have compilation error" do
      let(:answer_1) { create(:answer) }
      let(:answer_2) { create(:answer) }

      it "calls source_code_similarity and test_cases_output_similarity method" do
        expect(test_obj).to receive(:source_code_similarity)
        expect(test_obj).to receive(:test_cases_output_similarity)
        subject
      end
    end
  end


  describe '#compiler_output_similarity' do
    let(:answer_1) { create(:answer, :invalid_content, :whit_custom_callbacks) }

    context "when the output is the same" do
      let(:similarity) { compiler_output_similarity(answer_1, answer_1) }

      it "returns 100% os similarity" do
        expect(similarity).to eq(100)
      end
    end

    context "when the output is very similar" do
      let(:answer_2) { create(:answer, :whit_custom_callbacks, content: "test") }
      let(:similarity) { compiler_output_similarity(answer_1, answer_2) }

      it "returns high similarity" do
        expect(similarity >= 70).to be_truthy
      end
    end

    context "when the output is very different" do
      let(:answer_2) { create(:answer, compiler_output: "Fatal: Test error, this is a ficticius error") }
      let(:similarity) { compiler_output_similarity(answer_1, answer_2) }

      it "returns low similarity" do
        expect(similarity <= 30).to be_truthy
      end
    end
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

  describe '#test_cases_output_similarity' do
    let(:similarity) { test_cases_output_similarity(answer_1, answer_2) }
    let(:question) { create(:question) }
    let(:answer_1) { create_right_answer_to_question(question, callbacks: true) }

    context "when are equal" do
      let(:answer_2) { create_right_answer_to_question(question, callbacks: true) }

      it "returns 100% similarity" do
        expect(similarity).to eq(100)
      end
    end

    context "when are completely different" do
      let(:answer_2) { create(:answer, :whit_custom_callbacks, :ola_mundo, question: question) }

      it "returns 0% similarity" do
        expect(similarity).to eq(0)
      end
    end
  end

  describe '#get_error' do
    let(:error) { "This is the simulation of the compiler output\nThis is the error line\nHere I mention 'Error' again" }
    let!(:result) { get_error(error) }
    let(:expected) do
      expected = error.split("\n")
      expected.shift
      expected.join("\n")
    end

    it "returns the lines where mention the word 'error'"do
      expect(result).to eq(expected)
    end
  end

  describe '#users_similarity' do
    context "when users are very similar" do
      subject(:similarity) do
        user_1 = create(:user)
        user_2 = create(:user)
        team = create(:team, users: [user_1, user_2])

        exercise = create(:exercise)
        question = create(:question, exercise: exercise)
        create(:test_case, question: question)

        create(:answer, :whit_custom_callbacks, question: question, team: team, user: user_1)
        answer = create(:answer, :whit_custom_callbacks, question: question, team: team, user: user_2)

        ComputeSimilarityJob.perform_now(answer)

        users_similarity(user_1, user_2, team)
      end

      it "return high similarity" do
        expect(similarity >= 80).to be_truthy
      end
    end

    context "when users aren't very similar" do
      subject(:similarity) do
        user_1 = create(:user)
        user_2 = create(:user)
        team = create(:team, users: [user_1, user_2])

        exercise = create(:exercise)
        question = create(:question, exercise: exercise)
        create(:test_case, question: question)

        create(:answer, :params, :whit_custom_callbacks, question: question, team: team, user: user_1)
        answer = create(:answer, :whit_custom_callbacks, question: question, team: team, user: user_2)

        ComputeSimilarityJob.perform_now(answer)

        users_similarity(user_1, user_2, team)
      end

      it "return low similarity" do
        expect(similarity <= 30).to be_truthy
      end
    end
  end
end
