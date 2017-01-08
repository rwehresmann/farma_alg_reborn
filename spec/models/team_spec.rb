require 'rails_helper'

RSpec.describe Team, type: :model do

  describe "Validations -->" do
    let(:team) { build(:team) }

    it "is valid with valid attributes" do
      expect(team).to be_valid
    end

    it "is invalid with empty name" do
      team.name = ""
      expect(team).to_not be_valid
    end

    it "is invalid with empty password" do
      team.password = ""
      expect(team).to_not be_valid
    end

    it "is invalid with empty active flag" do
      team.active = ""
      expect(team).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to user (owner)" do
      expect(relationship_type(Team, :owner)).to eq(:belongs_to)
    end

    it "has and belongs to many users" do
      expect(relationship_type(Team, :users)).to eq(:has_and_belongs_to_many)
    end
  end
end
