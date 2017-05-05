require 'rails_helper'

describe AnswerQuery do
  describe '#user_correct_answers_from_team' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }
    let!(:user_team_answers) {
      create_list(:answer, 3, :correct, user: user, team: team)
    }

    subject {
      described_class.new.user_correct_answers_from_team(
        user: user, team: team, limit: limit
      )
    }

    before do
      # Answers that should not return.
      create(:answer, :correct, user: user)
      create(:answer, :incorrect, user: user, team: team)
    end

    context "when limit is specified" do
      let(:limit) { 1 }

      it { expect(subject).to eq([user_team_answers.first]) }
    end

    context "when no limit is specified" do
      let(:limit) { nil }

      it { expect(subject).to eq(user_team_answers) }
    end
  end
end
