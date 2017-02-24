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

    # 'nil', not empty, because BCrypt is been used and even a empty string
    # generates a hash.
    it "is invalid with nil password" do
      team.password = nil
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

    it "has many answers" do
      expect(relationship_type(Team, :answers)).to eq(:has_many)
    end

    it "has and belongs to many users" do
      expect(relationship_type(Team, :users)).to eq(:has_and_belongs_to_many)
    end

    it "has and belongs to many exercises" do
      expect(relationship_type(Team, :exercises)).to eq(:has_and_belongs_to_many)
    end
  end

  describe '#enrolled?' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    context "when user is enrolled" do
      before { team.enroll(user) }

      it "is true" do
        expect(team.enrolled?(user)).to be_truthy
      end
    end

    context "when user isn't enrolled" do
      it "is false" do
        expect(team.enrolled?(user)).to be_falsey
      end
    end

    context "when user is the team owner" do
      let(:user) { create(:user, :teacher) }
      let(:team) { create(:team, owner: user) }

      it "is false" do
        expect(team.enrolled?(user)).to be_falsey
      end
    end
  end

  describe '#unenroll' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    before do
      team.enroll(user)
      team.unenroll(user)
    end

    it "unenroll the user" do
      expect(team.enrolled?(user)).to be_falsey
    end
  end

  describe '#enroll' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    before { team.enroll(user) }

    it "enroll the user and create an UserScore record" do
      expect(team.enrolled?(user)).to be_truthy
      expect(UserScore.find_by(user: user, team: team)).to_not be_nil
    end

    context "when UserScore record already exists" do
      before do
        team.unenroll(user)
        team.enroll(user)
      end

      it "doesn't recreate it" do
        expect(UserScore.where(user: user, team: team).count).to eq(1)
      end
    end
  end
end
