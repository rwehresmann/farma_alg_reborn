require 'rails_helper'
require 'utils/incentive_ranking/builder'

describe IncentiveRanking::Builder do
  describe '#build' do
    let(:answers_number) { 2 }

    context "when there aren't user score records" do
      subject {
        described_class.new(
          target: [],
          team: create(:team),
          answers_number: answers_number,
          positions: { above: 1, below: 1 }
        ).build
      }

      it { is_expected.to be_empty }
    end

    context "when there are user score records" do
      let!(:user_score_1) { create(:user_score, team: team, score: 100) }
      let!(:user_score_2) { create(:user_score, team: team, score: 10) }
      let!(:user_score_3) { create(:user_score, team: team, score: 80) }
      let!(:user_score_4) { create(:user_score, team: team, score: 25) }

      subject(:team) do
        exercise = create(:exercise, questions: create_pair(:question))
        create(:team, exercises: [exercise])
      end

      # Note that target is the last user in ranking, so a ghost user should be
      # created.
      subject {
        described_class.new(
          target: user_score_4.user,
          team: team,
          answers_number: answers_number,
          positions: { above: 1, below: 1 }
        ).build
      }

      before do
        User.all.each { |user| create_list(:answer, 3, team: team, user: user) }
        # Crete these users only to pass in validation and create ghost users.
        team.users = create_list(:user, User.count)
      end

      it "respects the positions limit" do
        expect(subject.size).to eq(3)
      end

      it "brings the ranking ordered by score" do
        subject.size.times { |idx|
          expect(get_score(subject[idx]) >= get_score(subject[idx + 1]))
            .to be_truthy
        }
      end

      it "brings the ranking data with the right objects" do
        subject.each { |data|
          expect(data[:user].class).to eq(User)
          expect(data[:score].class).to eq(Fixnum)
          data[:answers].each { |answer| expect(answer.class).to eq(Answer) }
        }
      end

      it "brings the right number of answers" do
        subject.each { |data|
          expect(data[:answers].count).to eq(answers_number)
        }
      end
    end
  end

  private

  def get_score(object)
    return 0 if object.nil?
    object[:score]
  end
end
