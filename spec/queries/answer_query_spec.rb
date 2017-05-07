require 'rails_helper'

describe AnswerQuery do
  describe '#user_correct_answers' do
    let(:user) { create(:user) }

    context "when filter by team" do
      let(:team) { create(:team) }
      let!(:answers_to_return) {
        create_list(:answer, 2, :correct, user: user, team: team)
      }

      subject {
        described_class.new.user_correct_answers(user, to: { team: team })
      }

      # Answers who should not return.
      before do
        create(:answer, :incorrect, team: team, user: user)
        create(:answer, :correct, user: user)
        create(:answer, :correct, team: team)
      end

      it { expect(subject).to eq(answers_to_return) }
    end

    context "when filter by question" do
      let(:question) { create(:question) }
      let!(:answers_to_return) {
        create_list(:answer, 2, :correct, user: user, question: question)
      }

      subject {
        described_class.new.user_correct_answers(user, to: { question: question })
      }

      # Answers who should not return.
      before do
        create(:answer, :incorrect, question: question, user: user)
        create(:answer, :correct, user: user)
        create(:answer, :correct, question: question)
      end

      it { expect(subject).to eq(answers_to_return) }
    end

    context "when limit the number of results" do
      let!(:answers) { create_pair(:answer, :correct, user: user) }

      subject { described_class.new.user_correct_answers(user, limit: 1) }

      it { expect(subject).to eq([answers.first]) }
    end
  end

  describe '#user_last_correct_answer' do
    let(:user) { create(:user) }

    context "when filter by team" do
      let(:team) { create(:team) }
      let!(:answer_to_select) {
        create(:answer, :correct, team: team, user: user)
      }

      subject {
        described_class.new.user_last_correct_answer(user, to: { team: team })
      }

      before do
        answer_to_select.update_attribute(:created_at, Time.now + 2.day)
        # Answers who should not return.
        a1 = create(:answer, :incorrect, team: team, user: user)
        a2 = create(:answer, :correct, team: team)
        a3 = create(:answer, :correct, user: user)
        [a1, a2, a3].each { |answer|
          answer.update_attribute(:created_at, Time.now + 3.day)
        }
        a4 = create(:answer, :correct, team: team, user: user)
        a4.update_attribute(:created_at, Time.now + 1.day)
      end

      it { expect(subject).to eq([answer_to_select]) }
    end

    context "when filtered by question" do
      let(:question) { create(:question) }
      let!(:answer_to_select) {
        create(:answer, :correct, question: question, user: user)
      }

      subject {
        described_class.new.user_last_correct_answer(
          user, to: { question: question }
        )
      }

      before do
        answer_to_select.update_attribute(:created_at, Time.now + 2.day)
        # Answers who should not return.
        a1 = create(:answer, :incorrect, question: question, user: user)
        a2 = create(:answer, :correct, question: question)
        a3 = create(:answer, :correct, user: user)
        [a1, a2, a3].each { |answer|
          answer.update_attribute(:created_at, Time.now + 3.day)
        }
        a4 = create(:answer, :correct, question: question, user: user)
        a4.update_attribute(:created_at, Time.now + 1.day)
      end

      it { expect(subject).to eq([answer_to_select]) }
    end
  end

  describe "user_answers" do
    let(:user) { create(:user) }

    context "when filter by team" do
      let(:team) { create(:team) }
      let!(:answers_to_return) {
        create_list(:answer, 2, user: user, team: team)
      }

      subject {
        described_class.new.user_answers(user, to: { team: team })
      }

      # Answers who should not return.
      before do
        create(:answer, user: user)
        create(:answer, team: team)
      end

      it { expect(subject).to eq(answers_to_return) }
    end

    context "when filter by question" do
      let(:question) { create(:question) }
      let!(:answers_to_return) {
        create_list(:answer, 2, user: user, question: question)
      }

      subject {
        described_class.new.user_answers(user, to: { question: question })
      }

      # Answers who should not return.
      before do
        create(:answer, :correct, user: user)
        create(:answer, :correct, question: question)
      end

      it { expect(subject).to eq(answers_to_return) }
    end

    context "when limit the number of results" do
      let!(:answers) { create_pair(:answer, user: user) }

      subject { described_class.new.user_answers(user, limit: 1) }

      it { expect(subject).to eq([answers.first]) }
    end
  end

  describe '#team_answers' do
    let(:team) { create(:team) }

    context "when filtered by question" do
      let(:question) { create(:question) }
      let!(:answers_to_select) {
        create_pair(:answer, team: team, question: question) }

      subject { described_class.new.team_answers(team, question: question) }

      before do
        # Answers show should not return.
        create(:answer, question: question)
        create(:answer, team: team)
      end

      it { is_expected.to eq(answers_to_select) }
    end

    context "when limit the results" do
      let!(:answers_to_select) { create_pair(:answer, team: team) }

      subject { described_class.new.team_answers(team, limit: 1).count }

      it { is_expected.to eq(1) }
    end
  end

  describe '#team_correct_answers' do
    let(:team) { create(:team) }

    context "when filter by question" do
      let(:question) { create(:question) }
      let!(:answers_to_return) {
        create_list(:answer, 2, :correct, question: question, team: team)
      }

      subject {
        described_class.new.team_correct_answers(team, question: question)
      }

      # Answers who should not return.
      before do
        create(:answer, :incorrect, question: question, team: team)
        create(:answer, :correct, team: team)
        create(:answer, :correct, question: question)
      end

      it { is_expected.to eq(answers_to_return) }
    end

    context "when limit the number of results" do
      let!(:answers) { create_pair(:answer, :correct, team: team) }

      subject { described_class.new.team_correct_answers(team, limit: 1) }

      it { is_expected.to eq([answers.first]) }
    end
  end
end
