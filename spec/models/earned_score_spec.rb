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

  describe ".by_user" do
    let(:users) { create_pair(:user) }

    before do
      2.times { |i| create(:earned_score, user: users[i]) }
    end

    it "returns data of the right user" do
      expect(EarnedScore.by_user(users.first).map(&:user)).to eq([users.first])
    end
  end

  describe ".by_team" do
    let(:teams) { create_pair(:team) }

    before do
      2.times { |i| create(:earned_score, team: teams[i]) }
    end

    it "returns data of the right team" do
      expect(EarnedScore.by_team(teams.first).map(&:team)).to eq([teams.first])
    end
  end

  describe ".by_question" do
    let(:questions) { create_pair(:question) }

    before { 2.times { |i| create(:earned_score, question: questions[i]) } }

    it "returns data of the right team" do
      expect(EarnedScore.by_team(questions.first).map(&:question)).to eq([questions.first])
    end
  end

  describe ".starting_from" do
    let!(:time_now) { Time.now }
    let!(:to_return_1) { create(:earned_score, created_at: time_now) }
    let!(:to_return_2) { create(:earned_score, created_at: time_now + 1.day) }
    let!(:to_let_out) { create(:earned_score, created_at: time_now - 1.day) }

    it "returns the right data" do
      expected = [to_return_1, to_return_2]
      expect(EarnedScore.starting_from(time_now).to_a).to eq(expected)
    end
  end

  describe ".select_users" do
    let!(:records) { create_pair(:earned_score) }
    let!(:another_record) { create(:earned_score) }
    before { create_pair(:earned_score, user: EarnedScore.first.user) }

    context "when all table records should be considered" do
      let(:expected) { [records.first.user, records.last.user, another_record.user] }

      it "returns all users registered in the table" do
        received = EarnedScore.send(:select_users).to_a
        expect(received).to eq(expected)
      end
    end

    context "when records are specified" do
      let(:expected) { [records.first.user, records.last.user] }

      it "returns only the users from the records" do
        earned_scores = EarnedScore.where(id: records.map(&:id))
        received = EarnedScore.send(:select_users, earned_scores).to_a
        expect(received).to eq(expected)
      end
    end
  end

  describe ".time_rank" do
    let(:teams) { create_pair(:team) }

    before do
      teams.each do |team|
        4.times { create(:user, teams: [team]) }
        team.users.each_with_index do |user, index|
          create(:earned_score, user: user, team: team, score: index)
        end
      end
    end

    context "by team" do
      it "returns the right data" do
        limit = 3
        received = EarnedScore.rank_user(team: teams.first, limit: limit)
        expect(received.count).to eq(limit)
        (limit - 1).times do |i|
          expect(received[i][:score] > received[i + 1][:score]).to be_truthy
        end
      end
    end

    context "whit a 'starting_from' date" do
      let(:to_change) { EarnedScore.limit(3) }
      let!(:date) { Time.now }

      before do
        new_date = date
        to_change.each do |obj|
          obj.update(created_at: new_date)
          new_date += 1.day
        end
      end

      it "returns the right data" do
        received = EarnedScore.rank_user(starting_from: date).map { |obj| obj[:user] }
        expected = to_change.distinct.map(&:user)
        expected.each { |obj| expect(received.include?(obj)).to be_truthy }
      end
    end

    context "considering all records" do
      it "returns the right data" do
        limit = EarnedScore.count
        received = EarnedScore.rank_user
        expect(received.count).to eq(limit)
        (limit - 1).times do |i|
          expect(received[i][:score] > received[i + 1][:score])
        end
      end
    end
  end
end
