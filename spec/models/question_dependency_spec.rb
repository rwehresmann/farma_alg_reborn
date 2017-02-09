require 'rails_helper'

RSpec.describe QuestionDependency, type: :model do
  describe "Validations -->" do
    let(:dependency) do
      exercise = create(:exercise)
      questions = create_pair(:question, exercise: exercise)
      build(:question_dependency, question_1: questions.first, question_2: questions.last)
    end

    it "is valid whit valid attributes" do
      expect(dependency).to be_valid
    end

    it "is invalid whit empty operator" do
      dependency.operator = nil
      expect(dependency).to_not be_valid
    end

    it "is invalid whit an invalid operator" do
      dependency.operator = "XOR"
      expect(dependency).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to two questions" do
      expect(relationship_type(QuestionDependency, :question_1)).to eq(:belongs_to)
      expect(relationship_type(QuestionDependency, :question_2)).to eq(:belongs_to)
    end
  end

  describe ".create_symmetrical_record" do
    let(:exercise) { create(:exercise) }
    let(:questions) { create_pair(:question, exercise: exercise) }
    subject { QuestionDependency.create_symmetrical_record(questions.first,
                                                           questions.last,
                                                           QuestionDependency::DEPENDENCIES.first) }

    it "creates a symmetrical association" do
      expect { subject }.to change(QuestionDependency, :count).by(2)
      expect(questions.first.dependencies.count).to eq(1)
      expect(questions.first.dependencies.include?(questions.last)).to be_truthy
      expect(questions.last.dependencies.count).to eq(1)
      expect(questions.last.dependencies.include?(questions.first)).to be_truthy
    end
  end

  describe "#destroy_symmetrical_record" do
    let(:exercise) { create(:exercise) }
    let(:questions) { create_pair(:question, exercise: exercise) }
    before { QuestionDependency.create_symmetrical_record(questions.first,
                                                           questions.last,
                                                           QuestionDependency::DEPENDENCIES.first) }
    subject { QuestionDependency.first.destroy_symmetrical_record }

    it "destroys the symmetrical record" do
     expect { subject }.to change(QuestionDependency, :count).by(-2)
     expect(questions.first.dependencies.count).to eq(0)
     expect(questions.last.dependencies.count).to eq(0)
   end
  end
end
