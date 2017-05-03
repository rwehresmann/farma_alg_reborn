require 'rails_helper'
require 'utils/middlerizer'
require 'utils/incentive_ranking/ghost_user/builder'
require 'utils/incentive_ranking/ghost_user/applier'

describe IncentiveRanking::GhostUser::Applier do
  let(:target) { { user: build(:user), score: 100, answers: [] }}
  let(:incentive_ranking) { Middlerizer.new(middle: target, array: ranking) }
  let(:team) { create(:team) }
  let(:ghost_users_number) { 1 }

  subject {
    described_class.new(
      team: team,
      incentive_ranking: incentive_ranking,
      ghost_users_number: ghost_users_number
    ).apply
  }

  context "when target isn't last placed" do
    let(:ranking) {
      [
        target,
        { user: build(:user), score: 100, answers: [] }
      ]
    }

    it "doesn't add ghost users" do
      expect(subject.size).to eq(incentive_ranking.size)
    end
  end

  context "when team isn't large enought" do
    let(:ranking) {
      [
        { user: build(:user), score: 100, answers: [] },
        target
      ]
    }

    it "doesn't add ghost users" do
      expect(subject.size).to eq(incentive_ranking.size)
    end
  end

  context "when user is last placed and team is large enought" do
    let(:ranking) {
      [
        { user: build(:user), score: 100, answers: [] },
        target
      ]
    }

    let(:min_team_size) { incentive_ranking.size + ghost_users_number }

    before { team.users = create_list(:user, min_team_size) }

    it "adds ghost users" do
      expect(subject.size).to eq(min_team_size)
    end
  end
end
