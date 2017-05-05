require 'rails_helper'

describe UserScoreQuery do
  describe '#ranking' do
    let(:team) { create(:team) }
    let!(:user_score_1) { create(:user_score, score: 10, team: team) }
    let!(:user_score_2) { create(:user_score, score: 20, team: team) }
    let!(:user_score_3) { create(:user_score, score: 30, team: team) }
    let!(:user_score_4) { create(:user_score, score: 40) }

    subject { described_class.new.ranking(limit: limit, team: team) }

    context "when a limit is informed" do
      let(:limit) { 2 }

      it { expect(subject).to eq([user_score_3, user_score_2]) }
    end

    context "when no limit is informed" do
      let(:limit) { nil }

      it { expect(subject).to eq([user_score_3, user_score_2, user_score_1]) }
    end
  end
end
