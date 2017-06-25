require 'rails_helper'

describe AnswerCreator::Scorer::Increaser do
  context "when the question is classified as a task" do
    context "when the limit to start the variation in this question isn't reached" do
      it "increases the user score with the score attributed to the question" do
        user = create(:user)
        team = create(:team)
        question = create(:question, operation: "task", score: 50)
        user_score = create(:user_score, team: team, user: user, score: 0)

        described_class.new(user: user, team: team, question: question).increase

        earned_score = EarnedScore.where(
          user: user,
          team: team,
          question: question,
          score: question.score
        ).first

        expect(earned_score).to_not be_nil
        expect(earned_score.score).to eq question.score
        expect(user_score.reload.score).to eq question.score
      end
    end

    context "when the limit to start the variation in this questions is reached" do
      it "increases the user score with a variation of the score attributed to the question" do
        user = create(:user)
        team = create(:team)
        question = create(:question, operation: "task", score: 50)
        user_score = create(:user_score, team: team, user: user, score: 0)

        described_class::LIMIT_TO_START_VARIATION.times {
          create(:answer, question: question, user: user, team: team)
        }

        described_class.new(user: user, team: team, question: question).increase

        earned_score = EarnedScore.where(
          user: user,
          team: team,
          question: question
        ).first

        expect(earned_score.score).to_not be_nil
        expect(earned_score.score).to_not eq question.score
        expect(user_score.reload.score).to_not eq 0
      end
    end
  end

  context "when the question is classified as a challenge" do
    it "increases the user score with the score attributed to the question" do
      user = create(:user)
      team = create(:team)
      question = create(:question, operation: "challenge", score: 50)
      user_score = create(:user_score, team: team, user: user, score: 0)

      described_class.new(user: user, team: team, question: question).increase

      earned_score = EarnedScore.where(
        user: user,
        team: team,
        question: question,
        score: question.score
      ).first

      expect(earned_score.score).to eq question.score
      expect(user_score.reload.score).to eq question.score
    end
  end
end
