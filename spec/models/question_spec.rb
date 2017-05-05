require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "Validations -->" do
    let(:question) { build(:question) }

    it "is valid with valid attributes" do
      expect(question).to be_valid
    end

    it "is invalid with empty title" do
      question.title = nil
      expect(question).to_not be_valid
    end

    it "is invalid with empty score" do
      question.score = nil
      expect(question).to_not be_valid
    end

    it "is invalid with empty description" do
      question.description = nil
      expect(question).to_not be_valid
    end

    it "is invalid with empty operation" do
      question.operation = nil
      expect(question).to_not be_valid
    end

    it "is valid when operation is 'challenge'" do
      question.operation = "challenge"
      expect(question).to be_valid
    end

    it "is a task by default" do
      expect(question.operation).to eq("task")
    end

    context "when the question is deleted" do
      before do
        exercise = create(:exercise)
        questions = create_pair(:question, exercise: exercise)
        QuestionDependency.create!(question_1: questions[0],
                                   question_2: questions[1], operator: "OR")
      end

      subject { Question.first.destroy }

      it "destroys the question dependencies associated" do
        expect { subject }.to change(QuestionDependency, :count).by(-1)
      end
    end
  end

  describe "Relationships -->" do
    it "belongs to exercise" do
      expect(relationship_type(Question, :exercise)).to eq(:belongs_to)
    end

    it "has many test cases" do
      expect(relationship_type(Question, :test_cases)).to eq(:has_many)
    end

    it "has many answers" do
      expect(relationship_type(Question, :answers)).to eq(:has_many)
    end

    it "has many question dependencies" do
      expect(relationship_type(Question, :question_dependencies)).to eq(:has_many)
    end

    it "has many dependencies" do
      expect(relationship_type(Question, :dependencies)).to eq(:has_many)
    end
  end

  describe '#test_all' do
    let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
    subject(:results) do
      question = create(:question, test_cases_count: 2 )
      question.test_all(file_name: SecureRandom.hex, extension: "pas", source_code: source_code)
    end

    it "returns an array of results, containing hashes whit the test case object, correct flag and output" do
      expect(results.class).to eq(Array)
      expect(results.count).to eq(2)
      expect(results.first[:test_case]).to_not be_nil
      expect(results.first[:correct]).to_not be_nil
      expect(results.first[:output]).to_not be_nil
    end
  end

  describe "#dependency_with" do
    let(:exercise) { create(:exercise) }
    let(:questions) { create_pair(:question, exercise: exercise) }
    before { QuestionDependency.create!(question_1: questions.first,
                                        question_2: questions.last,
                                        operator: "OR") }

    it "returns dependency operator" do
      expect(questions.first.dependency_with(questions.last)).to eq("OR")
    end
  end

  describe '#answered_by_user?' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    let(:question) { create(:question) }

    context "when only correct answers can be considered" do
      context "when user already answered correctly" do
        subject { question.answered_by_user?(user, team: team, only_correct: true) }

        before { create(:answer, :correct, user: user, team: team, question: question) }

        it { expect(subject).to be_truthy }
      end

      context "when user didn't answered correctly yet" do
        subject { question.answered_by_user?(user, team: team, only_correct: true) }

        before do
          # Answers who should be ignored.
          create(:answer, :incorrect, user: user, team: team, question: question)
          create(:answer, :correct, user: user, team: team)
          create(:answer, :correct, user: user, question: question) 
        end

        it { expect(subject).to be_falsey }
      end
    end

    context "when any answer can be considered" do
      context "when user answered already" do
        subject { question.answered_by_user?(user, team: team) }

        before { create(:answer, user: user, team: team, question: question) }

        it { expect(subject).to be_truthy }
      end

      context "when user didn'y answered yet" do
        subject { question.answered_by_user?(user, team: team) }

        before do
          # Answers who should be ignored.
          create(:answer, user: user, team: team)
          create(:answer, user: user, question: question)
          create(:answer, team: team, question: question)
          create(:answer)
        end

        it { expect(subject).to be_falsey }
      end
    end
  end

  describe '#dependencies_of_operator' do
    let(:exercise) { create(:exercise) }
    let(:question) { create(:question, exercise: exercise) }
    let(:another_question) { create(:question, exercise: exercise) }

    before { QuestionDependency.create!(question_1: question,
                                        question_2: another_question,
                                        operator: "OR") }

    it "returns the dependencies with the specified operator" do
      expect(question.dependencies_of_operator("OR")).to eq([another_question])
    end
  end
end
