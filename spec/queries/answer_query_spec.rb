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

  describe '#user_last_correct_answer_from_team' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    let(:question) { create(:question) }
    let(:answer_1) {
      create(:answer, :correct, user: user, team: team, question: question)
    }
    let(:answer_2) {
      create(:answer, :correct, user: user, team: team, question: question)
    }
    let(:answer_3) {
      create(:answer, :correct, user: user, team: team, question: question)
    }
    let(:answer_4) {
      create(:answer, :incorrect, user: user, team: team, question: question)
    }
    let(:answer_5) { create(:answer, :correct, user: user, team: team) }
    let(:answer_6) { create(:answer, user: user, question: question) }
    let(:answer_7) { create(:answer, team: team, question: question) }

    subject {
      described_class.new.user_last_correct_answer_from_team(
        user: user, team: team, question: question
      )
    }

    before do
      answer_2.update_attribute(:created_at, Time.now + 2.day)
      # Update answers to be "created earlier" that the correct answer to return,
      # but they are inconsistent with the query args and should not be returned.
      [answer_4, answer_5, answer_6, answer_7].each { |answer|
        answer_2.update_attribute(:created_at, Time.now + 3.day)
      }
    end

    it { expect(subject).to eq([answer_2]) }
  end
end
