require 'rails_helper'
require 'utils/similarity_machine'

include SimilarityMachine

# TODO: Mock API to MOSS server to speed up these tests and avoid anoing errors
# of refused connection that sometimes happen.

describe SimilarityMachine do

  describe '#answers_similarity' do
    let(:test_obj) { Object.new }
    let(:question) { create(:question) }
    let!(:test_case) { create(:test_case, :hello_world, question: question) }

    subject(:similarity) do
      test_obj.extend(SimilarityMachine)
      test_obj.answers_similarity(answer_1, answer_2)
    end

    context "when they are very similar" do
      let(:answer_1) { create(:answer, :whit_custom_callbacks, :hello_world, question: question) }
      let(:answer_2) { create(:answer, :whit_custom_callbacks, :hello_world_2, question: question) }

      it { expect(similarity).to be >= 80 }
    end

    context "when they are very different" do
      let(:answer_1) { create(:answer, :whit_custom_callbacks, :hello_world, question: question) }
      let(:answer_2) { create(:answer, :whit_custom_callbacks, :params, question: question) }

      it { expect(similarity).to be <= 20 }
    end
  end

  describe '#source_code_similarity' do
    let(:similarity) { source_code_similarity(answer_1, answer_2) }
    let(:answer_1) { create(:answer) }

    context "when answers are very similar" do
      let(:answer_1) { create(:answer, :hello_world) }
      let(:answer_2) { create(:answer, :ola_mundo) }
      let!(:similarity) { source_code_similarity(answer_1, answer_2) }

      it { expect(similarity).to be >= 80 }
    end

    context "when answers are very different" do
      let(:answer_1) { create(:answer, :hello_world) }
      let(:answer_2) { create(:answer, :params) }
      let!(:similarity) { source_code_similarity(answer_1, answer_2) }

      it { expect(similarity).to be <= 20 }
    end
  end

  describe '#string_similarity' do
    context "when strings are very simmilar" do
      let(:string_1) { "This is a string, and a hole sentence." }
      let(:string_2) { "I call this a string, and a hole sentence." }
      let(:similarity) { string_similarity(string_1, string_2) }

      it { expect(similarity).to be >= 80 }
    end

    context "when strings are very different" do
      let(:string_1) { "This is a string, and a hole sentence." }
      let(:string_2) { "Heroes never die." }
      let(:similarity) { string_similarity(string_1, string_2) }

      it { expect(similarity).to be <= 20 }
    end
  end

  describe '#test_cases_output_similarity' do
    let(:question) { create(:question) }
    let!(:test_case) { create(:test_case, output: "Hello, world.\n", question: question) }

    context "when they are very similar" do
      let(:answer_1) { create(:answer, :whit_custom_callbacks, :hello_world, question: question) }
      let(:answer_2) { create(:answer, :whit_custom_callbacks, :hello_world_2, question: question) }
      let(:similarity) { test_cases_output_similarity(answer_1, answer_2) }

      it { expect(similarity).to be >= 80 }
    end

    context "when they are very different" do
      let(:answer_1) { create(:answer, :whit_custom_callbacks, :hello_world, question: question) }
      let(:answer_2) { create(:answer, :whit_custom_callbacks, :params, question: question) }
      let(:similarity) { test_cases_output_similarity(answer_1, answer_2) }

      it { expect(similarity).to be <= 20 }
    end
  end

  describe '#users_similarity' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user) }
    let(:question) { create(:question) }
    let!(:test_case) { create(:test_case, question: question, output: "Hello, world.\n") }
    let(:similarity) { users_similarity(users.first, users.last, team) }

    context "when users have high similarity" do
      before do
        answer_1 = create(:answer, :whit_custom_callbacks, :hello_world,
                          question: question, team: team, user: users.first)
        answer_2 = create(:answer, :whit_custom_callbacks, :hello_world_2,
                          question: question, team: team, user: users.last)
        [answer_1, answer_2].each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
      end

      it { expect(similarity).to be >= 80 }
    end

    context "when users have low similarity" do
      before do
        answer_1 = create(:answer, :whit_custom_callbacks, :hello_world,
                          question: question, team: team, user: users.first)
        answer_2 = create(:answer, :whit_custom_callbacks, :params,
                          question: question, team: team, user: users.last)
        [answer_1, answer_2].each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
      end

      it { expect(similarity).to be <= 20 }
    end

    context "when users haven't answered commmon questions" do
      before do
        answer = create(:answer, :whit_custom_callbacks, :hello_world,
                        question: question, team: team, user: users.first)
        ComputeAnswerSimilarityJob.perform_now(answer)
      end

      it { expect(similarity).to be <= 20 }
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
      create(:answer, user: users.first, question: questions.last, team: team)
    end

    it "returns the common questions answered by the specified users" do
      expect(common_questions_answered(users, team)).to eq([questions.first])
    end
  end

  describe '#question_similarity' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user, teams: [team]) }
    let(:question) { create(:question) }
    let!(:test_case) { create(:test_case, question: question) }
    let(:similarity) { question_similarity(question, users.first, users.last, team) }

    context "when similarity of the question between users is high" do
      before do
        answer_1 = create(:answer, :whit_custom_callbacks, :hello_world,
                          user: users.first, question: question, team: team)
        answer_2 = create(:answer, :whit_custom_callbacks, :hello_world_2,
                          user: users.last, question: question, team: team)
        [answer_1, answer_2].each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
      end

      it { similarity; expect(similarity).to be >= 80 }
    end

    context "when the similarity of question between the users is low" do
      before do
        answer_1 = create(:answer, :whit_custom_callbacks, :hello_world,
                          user: users.first, question: question, team: team)
        answer_2 = create(:answer, :whit_custom_callbacks, :params, user: users.last,
                          question: question, team: team)
        [answer_1, answer_2].each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
      end

      it { expect(similarity).to be <= 20 }
    end

    context "when non record of similarity is found" do
      it { expect(similarity).to be_nil }
    end
  end

  describe '#questions_similarity' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user, teams: [team]) }
    let(:questions) { create_pair(:question) }
    let(:test_cases) { create_pair(:test_case) }

    before do
      questions.first.test_cases << test_cases.first
      questions.last.test_cases << test_cases.last
    end

    context "when only questions that both users answered are specified" do
      let(:similarity) { questions_similarity(questions, users.first, users.last, team) }

      context "and the similarity of the questions between the users is high" do
        before do
          questions.each do |question|
            answer_1 = create(:answer, :whit_custom_callbacks, :hello_world,
                              user: users.first, question: question, team: team)
            answer_2 = create(:answer, :whit_custom_callbacks, :hello_world_2,
                              user: users.last, question: question, team: team)
            [answer_1, answer_2].each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
          end
        end

        it { expect(similarity).to be >= 80 }
      end

      context "and the similarity of the questions between the users is low" do
        before do
          questions.each do |question|
            answer_1 = create(:answer, :whit_custom_callbacks, :hello_world,
                              user: users.first, question: question, team: team)
            answer_2 = create(:answer, :whit_custom_callbacks, :params,
                              user: users.last, question: question, team: team)
            [answer_1, answer_2].each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
          end
        end

        it { expect(similarity).to be <= 20 }
      end
    end

    context "when questions that both users didn't answered are specified" do
      let(:similarity) { questions_similarity(questions, users.first, users.last, team) }
      it { expect(similarity).to eq(0) }
    end

    context "when a question where only one of the two users answered are specified" do
      let(:similarity) { questions_similarity(questions, users.first, users.last, team) }

      context "and the similarity of the questions between the users is high" do
        before do
          create(:answer, :whit_custom_callbacks, :hello_world, user: users.first,
                 question: questions.first, team: team)
          create(:answer, :whit_custom_callbacks, :hello_world_2, user: users.last,
                 question: questions.first, team: team)
          create(:answer, :whit_custom_callbacks, :hello_world, user: users.last,
                 question: questions.last, team: team)

          Answer.all.each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
        end

        it { expect(similarity).to be >= 80 }
      end

      context "and the similarity of the questions between the users is low" do
        before do
          answer_1 = create(:answer, :whit_custom_callbacks, :hello_world,
                            user: users.first, question: questions.first, team: team)
          answer_2 = create(:answer, :whit_custom_callbacks, :params,
                            user: users.last, question: questions.first, team: team)
          answer_3 = create(:answer, :whit_custom_callbacks, :hello_world,
                            user: users.last, question: questions.last, team: team)
          [answer_1, answer_2, answer_3].each { |answer|
            ComputeAnswerSimilarityJob.perform_now(answer)
          }
        end

        it { expect(similarity).to be <= 20 }
      end

      context "when no question is provided" do
        subject { questions_similarity([], users.first, users.last, team) }
        it { expect { subject }.to raise_error(RuntimeError) }
      end
    end
  end

  describe '#most_representative_question' do
    let(:team) { create(:team) }
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:user_3) { create(:user) }
    let(:question_1) { create(:question) }
    let(:question_2) { create(:question) }
    let(:question_3) { create(:question) }

    subject(:result) {
      most_representative_question([user_1, user_2, user_3], team)
    }

    context "when the users have common questions answered" do
      before do
        # Create a test case to each question.
        [question_1, question_2, question_3].each { |question|
          create(:test_case, :hello_world, question: question)
        }

        # Answers to question_1.
        create(:answer, :whit_custom_callbacks, :hello_world, user: user_1,
               question: question_1, team: team)
        create(:answer, :whit_custom_callbacks, :hello_world_2, user: user_2,
               question: question_1, team: team)
        create(:answer, :whit_custom_callbacks, :params, user: user_3,
               question: question_1, team: team)

        # Answers to question_2. They are very similar, but eliminated because
        # not all users answered this question.
        create(:answer, :whit_custom_callbacks, :hello_world, user: user_1,
               question: question_2, team: team)
        create(:answer, :whit_custom_callbacks, :hello_world, user: user_2,
               question: question_2, team: team)

        # Answers to question_3. All users answered, an is the questions with
        # the higgest similarity average.
        create(:answer, :whit_custom_callbacks, :hello_world, user: user_1,
               question: question_3, team: team)
        create(:answer, :whit_custom_callbacks, :hello_world_2, user: user_2,
               question: question_3, team: team)
        create(:answer, :whit_custom_callbacks, :hello_world_2, user: user_3,
               question: question_3, team: team)

        Answer.all.each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
      end

      it { expect(result).to eq(question_3) }
    end

    context "when none common question answered is found" do
      before do
        create(:answer, :whit_custom_callbacks, :hello_world, user: user_1,
               question: question_1, team: team)
        create(:answer, :whit_custom_callbacks, :hello_world_2, user: user_2,
               question: question_2, team: team)
        create(:answer, :whit_custom_callbacks, :hello_world_2, user: user_3,
               question: question_3, team: team)

        Answer.all.each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) }
      end

      it { expect(result).to be_nil }
    end
  end

  describe '#most_representative_answer' do
    let(:team) { create(:team) }
    let(:users) { create_pair(:user) }
    let(:question) { create(:question) }
    let!(:test_case) { create(:test_case, :hello_world, question: question) }
    let!(:answer_1) { create(:answer, :whit_custom_callbacks, :hello_world_2,
                             question: question, team: team, user: users.first) }
    let!(:answer_2) { create(:answer, :whit_custom_callbacks, :hello_world,
                             question: question, team: team, user: users.last) }
    let!(:answer_3) { create(:answer, :whit_custom_callbacks, :params,
                             question: question, team: team, user: users.first) }

    # Answer_1 should be the result. In fact, answer_2 could be a valid result
    # too, because the similarity compute is the same that answer_1. However
    # answer_1 is the first answer create in this case and returns first.
    subject(:result) { most_representative_answer(question, users, team) }

    before { Answer.all.each { |answer| ComputeAnswerSimilarityJob.perform_now(answer) } }

    it { expect(result == answer_1 || result == answer_2).to be_truthy }
  end
end
