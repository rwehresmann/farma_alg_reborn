require 'rails_helper'

describe QuestionQuery do
  describe '#questions_answered_by_user' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    let(:questions) { create_pair(:question) }

    subject {
      described_class.new.questions_answered_by_user(
        user, team: team, limit: limit
      )
    }

    before do
      create(:answer, user: user, question: questions[0], team: team)
      create(:answer, user: user, question: questions[1], team: team)
      # Answers to questions who should be ignored.
      create(:answer, user: user, question: questions[1], team: team)
      create(:answer, user: user)
      create(:answer, team: team)
    end

    context "when limit is specified" do
      let(:limit) { 1 }

      it { expect(subject).to eq([questions[0]]) }
    end

    context "when no limit is specified" do
      let(:limit) { nil }

      it { expect(subject).to eq(questions) }
    end
  end
end
