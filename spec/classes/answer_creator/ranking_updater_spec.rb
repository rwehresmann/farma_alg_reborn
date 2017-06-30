require 'rails_helper'

describe AnswerCreator::RankingUpdater do
  describe "#update_position" do
    it "updates the position field" do
      team = create(:team)
      user_score_1 = create(:user_score, team: team, score: 30)
      user_score_2 = create(:user_score, team: team, score: 20)
      user_score_3 = create(:user_score, team: team, score: 40)

      described_class.new(team).update_position

      expect(user_score_1.reload.position).to eq 2
      expect(user_score_2.reload.position).to eq 3
      expect(user_score_3.reload.position).to eq 1
    end
  end

  it "updates the start_position_on_day" do
    team = create(:team)
    user_score_1 = create(:user_score, team: team, score: 30)
    user_score_2 = create(:user_score, team: team, score: 20)
    user_score_3 = create(:user_score, team: team, score: 40)

    described_class.new(team).update_start_position_on_day

    expect(user_score_1.reload.start_position_on_day).to eq 2
    expect(user_score_2.reload.start_position_on_day).to eq 3
    expect(user_score_3.reload.start_position_on_day).to eq 1
  end
end
