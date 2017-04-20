require 'rails_helper'

RSpec.describe EarnedScore, type: :model do
  describe "Validations" do
    let(:earned_score) { create(:earned_score) }

    it "is valid whit valid attributes" do
      expect(earned_score).to be_valid
    end

    it "is invalid whit empty earned score" do
      earned_score.score = nil
      expect(earned_score).to_not be_valid
    end
  end

  describe "Relationships" do
    it "belongs to user" do
      expect(relationship_type(EarnedScore, :user)).to eq(:belongs_to)
    end

    it "belongs to question" do
      expect(relationship_type(EarnedScore, :question)).to eq(:belongs_to)
    end

    it "belongs to user" do
      expect(relationship_type(EarnedScore, :team)).to eq(:belongs_to)
    end
  end

  describe ".by_user" do
    let(:users) { create_pair(:user) }

    before do
      2.times { |i| create(:earned_score, user: users[i]) }
    end

    it "returns data of the right user" do
      expect(EarnedScore.by_user(users.first).map(&:user)).to eq([users.first])
    end
  end

  describe ".by_team" do
    let(:teams) { create_pair(:team) }

    before do
      2.times { |i| create(:earned_score, team: teams[i]) }
    end

    it "returns data of the right team" do
      expect(EarnedScore.by_team(teams.first).map(&:team)).to eq([teams.first])
    end
  end

  describe ".by_question" do
    let(:questions) { create_pair(:question) }

    before { 2.times { |i| create(:earned_score, question: questions[i]) } }

    it "returns data of the right team" do
      expect(EarnedScore.by_team(questions.first).map(&:question)).to eq([questions.first])
    end
  end

  describe ".starting_from" do
    let!(:time_now) { Time.now }
    let!(:to_return_1) { create(:earned_score, created_at: time_now) }
    let!(:to_return_2) { create(:earned_score, created_at: time_now + 1.day) }
    let!(:to_let_out) { create(:earned_score, created_at: time_now - 1.day) }

    it "returns the right data" do
      expected = [to_return_1, to_return_2]
      expect(EarnedScore.starting_from(time_now).to_a).to eq(expected)
    end
  end

  describe ".select_users" do
    let!(:records) { create_pair(:earned_score) }
    let!(:another_record) { create(:earned_score) }
    before { create_pair(:earned_score, user: EarnedScore.first.user) }

    context "when all table records should be considered" do
      let(:expected) { [records.first.user, records.last.user, another_record.user] }

      it "returns all users registered in the table" do
        received = EarnedScore.send(:select_users).to_a
        expect(received).to eq(expected)
      end
    end

    context "when records are specified" do
      let(:expected) { [records.first.user, records.last.user] }

      it "returns only the users from the records" do
        earned_scores = EarnedScore.where(id: records.map(&:id))
        received = EarnedScore.send(:select_users, earned_scores).to_a
        expect(received).to eq(expected)
      end
    end
  end

  describe ".ranking" do
    context "when used to calculate the ranking of a team in a certain period of time" do
      let(:users) { create_list(:user, 4) }
      let(:teams) { create_pair(:team, users: users) }
      let(:team_to_search) { teams.last }
      let(:questions) { create_list(:question, 4, test_cases: [create(:test_case, :hello_world)]) }
      let(:start_date) { Time.now }
      let(:score_to_earn) { 20 }

      subject(:set_data) do
        # Create answers who whould be ignored.
        # Answers from a team that will not be searched:
        set_earned_score(questions, users.first, teams.first, start_date)

        # Answer out of the date range to search:
        set_earned_score(questions, users.third, team_to_search, start_date - 1.month)

        # Create answer to the searched team.
        # users.first score = 80:
        set_earned_score(questions, users.first, team_to_search, start_date)

        # users.second score = 60:
        set_earned_score(questions[0..2], users.second, team_to_search, start_date)

        # users.third score = 40:
        set_earned_score([questions.first], users.third, team_to_search, start_date)
        create(:earned_score, team: team_to_search, question: questions.second,
               user: users.third, created_at: start_date + 3.day, score: score_to_earn)

        # users.last score = 20:
        set_earned_score([questions.first], users.last, team_to_search, start_date)
      end

      context "with a limit specified" do
        let(:expected) {
                        [
                          { user: users.first, score: 80 },
                          { user: users.second, score: 60 },
                          { user: users.third, score: 40 }
                        ]
                      }

        subject { EarnedScore.ranking(team: teams.last, starting_from: start_date,
                                      limit: 3) }

        before { set_data }

        it { expect(subject).to eq(expected) }
      end

      context "without a limit specified" do
        let(:expected) {
                        [
                          { user: users.first, score: 80 },
                          { user: users.second, score: 60 },
                          { user: users.third, score: 40 },
                          { user: users.last, score: 20 }
                        ]
                      }

        subject { EarnedScore.ranking(team: teams.last, starting_from: start_date) }

        before { set_data }

        it { expect(subject).to eq(expected) }
      end

      context "with a limit bigger than the quantity of students in the team" do
        let(:expected) {
                        [
                          { user: users.first, score: 80 },
                          { user: users.second, score: 60 },
                          { user: users.third, score: 40 },
                          { user: users.last, score: 20 }
                        ]
                      }

        subject { EarnedScore.ranking(team: teams.last, starting_from: start_date,
                                      limit: users.count + 10) }

        before { set_data }

        it { expect(subject).to eq(expected) }
      end

      context "without any data to rank" do
        it { expect{ EarnedScore.ranking }.to_not raise_error }
      end
    end
  end

    private

    def set_earned_score(questions, user, team, date)
      questions.each { |question|
        create(:earned_score, team: team, question: question,
               user: user, created_at: date, score: score_to_earn)
      }
    end
end
