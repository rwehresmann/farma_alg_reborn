require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "Validations -->" do
    let(:answer) { build(:answer) }

    it "is valid with valid attributes" do
      expect(answer).to be_valid
    end

    it "is invalid with empty content" do
      answer.content = ""
      expect(answer).to_not be_valid
    end

    it "is invalid with empty correct flag" do
      answer.correct = ""
      expect(answer).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to user" do
      expect(relationship_type(Answer, :user)).to eq(:belongs_to)
    end

    it "belongs to question" do
      expect(relationship_type(Answer, :question)).to eq(:belongs_to)
    end
  end
end
