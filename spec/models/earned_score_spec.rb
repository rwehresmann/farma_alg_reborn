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
    it "returns data of the right user" do
      users = create_list(:user, 3)

      earned_scores_to_return = create_pair(:earned_score, user: users[0])
      users[1..2].each { |user| create(:earned_score, user: user) }

      expect(EarnedScore.by_user(users[0]).to_a).to eq earned_scores_to_return
    end
  end

  describe ".by_team" do
    it "returns data of the right team" do
      teams = create_list(:team, 3)

      earned_scores_to_return = create_pair(:earned_score, team: teams[0])
      teams[1..2].each { |team| create(:earned_score, team: team) }

      expect(EarnedScore.by_team(teams[0]).to_a).to eq earned_scores_to_return
    end
  end

  describe ".by_question" do
    it "returns data of the right question" do
      questions = create_list(:question, 3)

      earned_scores_to_return = create_pair(:earned_score, question: questions[0])
      questions[1..2].each { |question| create(:earned_score, question: question) }

      expect(EarnedScore.by_question(questions[0])).to eq earned_scores_to_return
    end
  end

  describe ".starting_from" do
    it "returns earned score records starting from the informed date" do
      current_date = Time.now

      record_1 = create(:earned_score, created_at: current_date)
      create(:earned_score, created_at: current_date - 1.day)
      record_2 = create(:earned_score, created_at: current_date + 1.day)

      expect(
        EarnedScore.starting_from(current_date).to_a
      ).to eq [record_1, record_2]
    end
  end

  describe ".ranking" do
    context "when used to calculate the ranking of a team in a certain period of time" do
      context "when not limiting the results" do
        it "returns the complet ranking from the team" do
          current_date = Time.now
          users = create_list(:user, 4)
          teams = create_pair(:team)

          set_earned_scores(users, teams, current_date)

          result = described_class.ranking(
            team: teams[0],
            starting_from: current_date
          )
          expected_result = [
            { user: users[1], score: 30 },
            { user: users[2], score: 20 },
            { user: users[0], score: 10 }
          ]

          expect(result).to eq expected_result
        end
      end
    end

    context "when limiting the results" do
      it "returns the ranking from the team respecting the limit specified" do
        current_date = Time.now
        users = create_list(:user, 4)
        teams = create_pair(:team)

        set_earned_scores(users, teams, current_date)

        result = described_class.ranking(
          team: teams[0],
          starting_from: current_date,
          limit: 2
        )
        expected_result = [
          { user: users[1], score: 30 },
          { user: users[2], score: 20 }
        ]

        expect(result).to eq expected_result
      end
    end
  end

  def set_earned_scores(users, teams, current_date)
    create(
      :earned_score,
      user: users[0],
      team: teams[0],
      score: 10,
      created_at: current_date
    )
    create(
      :earned_score,
      user: users[1],
      team: teams[0],
      score: 30,
      created_at: current_date + 1.day
    )
    create(
      :earned_score,
      user: users[2],
      team: teams[0],
      score: 20,
      created_at: current_date + 2.day
    )

    # These records must be ignored >>

    create(
      :earned_score,
      user: users[3],
      team: teams[0],
      score: 100,
      created_at: current_date - 1.days
    )
    create(
      :earned_score,
      user: users[1],
      team: teams[1],
      score: 100,
      created_at: current_date
    )
    create(
      :earned_score,
      user: users[0],
      team: teams[1],
      score: 100,
      created_at: current_date
    )
  end
end
