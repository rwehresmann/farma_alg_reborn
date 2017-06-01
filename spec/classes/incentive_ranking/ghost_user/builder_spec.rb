require 'rails_helper'

describe IncentiveRanking::GhostUser::Builder do
  describe '#build' do
    let(:answers) { build_list(:answer, 5, :correct) }
    let(:base_data) { { user: build(:user), score: 100, answers: answers } }

    subject(:team) do
      exercise = create(:exercise, questions: create_pair(:question))
      create(:team, exercises:[exercise])
    end

    subject {
      described_class.new(
        base_data: base_data,
        team: team
      ).build(ghost_users_number)
    }

    context "when none ghost user should be created" do
      let(:ghost_users_number) { 0 }

      it { expect(subject.count).to eq(ghost_users_number) }
    end

    context "when one ghost user should be created" do
      let(:ghost_users_number) { 1 }

      it { expect(subject.count).to eq(ghost_users_number) }

      it "creates each user answers with lass or equal number of correct answers
          than how is above him" do
          condition = correct_answers_count(base_data) >= correct_answers_count(subject.first)
          expect(condition).to be_truthy
      end
    end

    context "when three ghost users should be created" do
      let(:ghost_users_number) { 3 }

      it { expect(subject.count).to eq(ghost_users_number) }

      it "creates each user answers with lass or equal number of correct answers than how is above him" do
          correct_answers_expectation(subject)
      end
    end
  end

  private

  def correct_answers_count(ghost_user)
    count = 0
    ghost_user[:answers].each { |answer|
      count += 1 if answer.correct
    } unless ghost_user.nil?

    count
  end

  def correct_answers_expectation(ghost_users)
    ghost_users.count.times do |idx|
      condition = correct_answers_count(ghost_users[idx]) >=
                  correct_answers_count(ghost_users[idx + 1])
      expect(condition).to be_truthy
    end
  end
end
