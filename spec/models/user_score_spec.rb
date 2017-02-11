require 'rails_helper'

RSpec.describe UserScore, type: :model do
  describe "Validations -->" do
    let(:user_score) { build(:user_score) }

    it "is valid whit valid attributes" do
      expect(user_score).to be_valid
    end

    it "is invalid whit empty score" do
      user_score.score = nil
      expect(user_score).to_not be_valid
    end

    it "has 0 as default score" do
      expect(user_score.score).to eq(0)
    end
  end

  describe "Relationships -->" do
    it "belongs to user" do
      expect(relationship_type(UserScore, :user)).to eq(:belongs_to)
    end

    it "belongs to user" do
      expect(relationship_type(UserScore, :team)).to eq(:belongs_to)
    end
  end
end
