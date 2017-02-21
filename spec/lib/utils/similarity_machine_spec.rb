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

    it "returns in a string the lines where mention the word 'error'"do
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

        ComputeAnswerSimilarityJob.perform_now(answer)

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

        ComputeAnswerSimilarityJob.perform_now(answer)

        users_similarity(user_1, user_2, team)
      end

      it "returns low similarity" do
        expect(similarity <= 30).to be_truthy
      end
    end
  end

  describe '#most_representative' do
    let(:hash) { { first: 1, second: 2, third: 3 } }

    it "return the key with the biggest value" do
      expect(most_representative(hash)).to eq(:third)
    end

    context "when the biggest values is repeated" do
      before { hash[:fourth] = 3 }

      it "return only one key" do
        biggest = most_representative(hash)
        expect(biggest == :third || biggest == :fourth).to be_truthy
      end
    end
  end

  describe '#common_questions_answered' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user, teams: [team]) }
    let(:questions) { create_pair(:question) }

    before do
      users.each { |user| create(:answer, user: user, question: questions.first,
                                 team: team) }
    end

    it "returns the questions answered by the specified users" do
      expect(common_questions_answered(users, team)).to eq([questions.first])
    end
  end

  describe '#question_similarity' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user, teams: [team]) }
    let(:question) { create(:question) }

    before do
      users.each { |user| create_pair(:answer, user: user,
                                         question: question, team: team) }
      answers = Answer.by_team(team).by_question(question).to_a
      AnswerConnection.create_simetrical_record(answers.first, answers.last, 100)
      AnswerConnection.create_simetrical_record(answers[1], answers[2], 50)
    end

    it "returns the right similarity" do
      expect(question_similarity(question, users.first, users.last, team)).to eq(75)
    end
  end

  describe '#questions_similarity' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user, teams: [team]) }
    let(:questions) { create_pair(:question) }

    before do
      users.each do |user|
        questions.each do |question|
          create_pair(:answer, user: user, question: question, team: team)
        end
      end

      2.times do |i|
        answers = Answer.by_team(team).by_question(questions[i]).to_a
        AnswerConnection.create_simetrical_record(answers.first, answers.last, 100)
        AnswerConnection.create_simetrical_record(answers[1], answers[2], 50)
      end
    end

    context "when only questions that both users answered are specified" do
      it "returns the right similarity" do
        expect(questions_similarity(questions, users.first, users.last, team)).to eq(75)
      end
    end

    context "when questions that both users didn't answered are specified" do
      before { create(:question) }

      it "returns the right similarity" do
        expect(questions_similarity(questions, users.first, users.last, team)).to eq(75)
      end
    end

    context "when a question where only one of the two users answered are specified" do
      before do
        question = create(:question)
        create(:answer, user: users.first, team: team, question: question)
      end

      it "returns the right similarity" do
        expect(questions_similarity(questions, users.first, users.last, team)).to eq(75)
      end
    end
  end

  describe '#most_representative_question' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user, teams: [team]) }
    let(:questions) { create_pair(:question) }

    context "when the users have common questions answered" do
      before do
        users.each do |user|
          questions.each do |question|
            create_pair(:answer, user: user, question: question, team: team)
          end
        end

        2.times do |i|
          answers = Answer.by_team(team).by_question(questions[i]).to_a
          AnswerConnection.create_simetrical_record(answers.first, answers.last, i)
          AnswerConnection.create_simetrical_record(answers[1], answers[2], i)
        end
      end

      it "returns the questions whit greater similarity between the specified users" do
        expect(most_representative_question(users, team)).to eq(questions.last)
      end
    end

    context "when the users haven't common questions answered" do
      it "returns nil" do
        expect(most_representative_question(users, team)).to be_nil
      end
    end
  end

  describe '#most_representative_answer' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user) }
    let(:question) { create(:question) }

    before do
      users.each { |user| create_pair(:answer, user: user, question: question,
                                      team: team) }

      answers = Answer.by_team(team).by_question(question).to_a
      answers.count.times do |i|
        answer_1 = answers.shift
        answers.each do |answer_2|
          AnswerConnection.create_simetrical_record(answer_1, answer_2, 100 - i)
        end
      end
    end

    it "returns the answer whit biggest similarity" do
      expect(most_representative_answer(question, users, team)).to eq(Answer.first)
    end
  end
end
