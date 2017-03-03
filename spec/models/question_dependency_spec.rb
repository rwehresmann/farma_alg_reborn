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
end
