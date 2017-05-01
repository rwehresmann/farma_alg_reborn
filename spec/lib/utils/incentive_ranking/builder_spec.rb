require 'rails_helper'
require 'utils/incentive_ranking/builder'

describe IncentiveRanking::Builder do
  describe '#build' do
    let(:team)   { create(:team) }

    let!(:user_score_1) { create(:user_score, team: team, score: 100) }
    let!(:user_score_2) { create(:user_score, team: team, score: 10) }
    let!(:user_score_3) { create(:user_score, team: team, score: 80) }
    let!(:user_score_4) { create(:user_score, team: team, score: 25) }

    before {
      User.all.each { |user| create_list(:answer, 3, team: team, user: user) }
    }

    subject {
      described_class.new(
        target: user_score_3,
        team: team,
        answers_number: 2,
        positions: { above: 1, below: 3 }
      ).build
    }

    it "respects the positions limit" do
      expect(subject.count).to eq(3)
    end

    it "brings the ranking ordered by score" do
      expect(subject.first[:score] >= subject.second[:score]).to be_truthy
      expect(subject.second[:score] >= subject.last[:score]).to be_truthy
    end

    it "brings the ranking in the right format" do
      subject.each { |data|
        expect(data.keys).to eq([:user, :score, :answers])
      }
    end

    it "matchs with the right data" do
      expect(subject.first[:user]).to eq(user_score_1.user)
      expect(subject.first[:score]).to eq(user_score_1.score)
      expect(subject.second[:user]).to eq(user_score_3.user)
      expect(subject.second[:score]).to eq(user_score_3.score)
      expect(subject.last[:user]).to eq(user_score_4.user)
      expect(subject.last[:score]).to eq(user_score_4.score)
    end

    it "brings the right number of answers" do
      subject.each { |data|
        expect(data[:answers].count).to eq(2)
      }
    end
  end
end
