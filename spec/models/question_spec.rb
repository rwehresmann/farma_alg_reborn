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

    it "is invalid with empty registered score" do
      question.registered_score = nil
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
        QuestionDependency.create_symmetrical_record(questions[0], questions[1], "OR")
      end

      subject { Question.first.destroy }

      it "destroys the question dependencies associated" do
        expect { subject }.to change(QuestionDependency, :count).by(-2)
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

  describe "Callbacks -->" do
    describe '#set_mutable_score' do
      context "when questions is a challenge" do
        let(:question) { create(:question, :challenge) }

        it "doesn't set mutable score" do
          expect(question.mutable_score).to be_nil
        end
      end

      context "when question is a task" do
        let(:question) { create(:question) }

        it "sets mutable score with registered score" do
          expect(question.mutable_score).to eq(question.registered_score)
        end
      end
    end
  end

  describe '#test_all' do
    let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
    let(:results) do
      question = create(:question, test_cases_count: 2 )
      question.test_all("test_file", "pas", source_code)
    end

    it "returns an array of results, containing hashes whit the test case object, status and output" do
      expect(results.class).to eq(Array)
      expect(results.count).to eq(2)
      expect(results.first[:test_case]).to_not be_nil
      expect(results.first[:status]).to_not be_nil
      expect(results.first[:output]).to_not be_nil
    end
  end

  describe "#dependency_with" do
    let(:exercise) { create(:exercise) }
    let(:questions) { create_pair(:question, exercise: exercise) }
    before { QuestionDependency.create_symmetrical_record(questions.first,
                                                          questions.last, "OR") }

    it "returns dependency operator" do
      expect(questions.first.dependency_with(questions.last)).to eq("OR")
    end
  end
end
