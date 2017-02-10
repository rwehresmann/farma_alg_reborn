require 'rails_helper'

RSpec.describe EarnedScore, type: :model do
  describe "Validations" do
    let(:earned_score) { create(:earned_score) }

    it "is valid whit valid attributes" do
      expect(earned_score).to be_valid
    end

    it "is invalid whit empty earned score" do
      earned_score.score = nil
      expect(earned_score).to_not be_valid
    end
  end

  describe "Relationships" do
    it "belongs to user" do
      expect(relationship_type(EarnedScore, :user)).to eq(:belongs_to)
    end

    it "belongs to question" do
      expect(relationship_type(EarnedScore, :question)).to eq(:belongs_to)
    end

    it "belongs to user" do
      expect(relationship_type(EarnedScore, :team)).to eq(:belongs_to)
    end
  end
end
