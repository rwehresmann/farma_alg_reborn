require 'rails_helper'

RSpec.describe Recommendation, type: :model do
  describe "Validations" do
    it "is valid with valid attributes" do
      expect(build(:recommendation)).to be_valid
    end

    it "is invalid without a team" do
      recommendation = build(:recommendation, team: nil)
      expect(recommendation).to_not be_valid
    end
  end

  describe "Relationships" do
    it { expect(relationship_type(Recommendation, :team)).to eq(:belongs_to) }

    it { expect(relationship_type(Recommendation, :users)).to eq(:has_many) }

    it { expect(relationship_type(Recommendation, :answers)).to eq(:has_many) }
  end
end
