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

  describe ".by_user" do
    let(:users) { create_pair(:user) }

    before do
      team = create(:team)
      2.times { |i| create(:user_score, user: users[i], team: team) }
    end

    it "returns data of the right user" do
      expect(UserScore.by_user(users.first).map(&:user)).to eq([users.first])
    end
  end

  describe ".by_team" do
    let(:teams) { create_pair(:team) }

    before do
      user = create(:user)
      2.times { |i| create(:user_score, user: user, team: teams[i]) }
    end

    it "returns data of the right team" do
      expect(UserScore.by_team(teams.first).map(&:team)).to eq([teams.first])
    end
  end

  describe ".top" do
    before { 4.times { create(:user_score) } }

    it "returns the top x" do
      expect(UserScore.top(2).count).to eq(2)
    end
  end

  describe ".rank" do
    let(:teams) { create_pair(:team) }

    before do
      6.times do
        create(:user, teams: [teams.first])
        create(:user, teams: [teams.last])
      end

      users = User.all
      teams.each do |team|
        users.count.times do |i|
          UserScore.create(user: users[i], team: team, score: i)
        end
      end
    end

    context "by team" do
      it "returns the right data ordered by score" do
        received = UserScore.rank(team: teams.first, limit: 3).to_a
        expected = UserScore.where(team: teams.first).order(id: :desc).limit(3).to_a
        expect(received).to eq(expected)
      end
    end

    context "by user" do
      let(:user_to_change) { User.first }
      let(:score_to_change) { UserScore.by_team(teams.first).by_user(user_to_change).first }

      before { score_to_change.update_attributes(score: 1000) }

      it "returns the right data ordered by score" do
        received = UserScore.rank(user: user_to_change).to_a
        expected = UserScore.by_user(user_to_change).to_a
        expect(received).to eq(expected)
      end
    end
  end
end
