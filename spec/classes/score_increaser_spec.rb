require 'rails_helper'

describe ScoreIncreaser do
  context "when the question is classified as a task" do
    context "when the limit to start the variation in this question is reached" do
      it "increases the user score with the score attributed to the question" do
        user = create(:user)
        team = create(:team)
        question = create(:question, operation: "task", score: 50)

        ScoreIncreaser.new(user: user, team: team, question: question).increase

        earned_score = EarnedScore.where(
          user: user,
          team: team,
          question: question,
          score: question.score
        ).first

        expect(earned_score).to_not be_nil
      end
    end

    context "when the limit to start the variation in this questions isn't reached" do
      it "increases the user score with a variation of the score attributed to the question" do
        user = create(:user)
        team = create(:team)
        question = create(:question, operation: "task", score: 50)

        ScoreIncreaser::LIMIT_TO_START_VARIATION.times {
          create(:answer, question: question, user: user, team: team)
        }

        ScoreIncreaser.new(user: user, team: team, question: question).increase

        earned_score = EarnedScore.where(
          user: user,
          team: team,
          question: question
        ).first

        expect(earned_score.score).to_not eq question.score
      end
    end
  end

  context "when the question is classified as a challenge" do
    it "increases the user score with the score attributed to the question" do
      user = create(:user)
      team = create(:team)
      question = create(:question, operation: "challenge", score: 50)

      ScoreIncreaser.new(user: user, team: team, question: question).increase

      earned_score = EarnedScore.where(
        user: user,
        team: team,
        question: question,
        score: question.score
      ).first

      expect(earned_score).to_not be_nil
    end
  end
end
