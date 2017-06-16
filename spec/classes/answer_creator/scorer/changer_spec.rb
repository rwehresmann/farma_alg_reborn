require 'rails_helper'

describe AnswerCreator::Scorer::Changer do
  describe "#change" do
    context "when answer is correct" do
      context "when the user already correct answered the question" do
        it "doesn't update the user score" do
          user = create(:user)
          team = create(:team)
          question = create(:question)

          answers = create_pair(
            :answer,
            :correct,
            user: user,
            team: team,
            question: question
          )

          changer = described_class.new(answers[1])

          expect { changer.change }.to_not change(EarnedScore, :count)
        end
      end

      context "when the user haven't already correct answered the question" do
        it "updates the user score" do
          user = create(:user)
          team = create(:team)
          question = create(:question)

          answer = create(
            :answer,
            :correct,
            user: user,
            team: team,
            question: question
          )

          changer = described_class.new(answer)

          expect { changer.change }.to change(EarnedScore, :count).by 1
        end
      end
    end

    context "when answer is incorrect" do
      context "when the user already correct answered the question" do
        it "doesn't update the user score" do
          user = create(:user)
          team = create(:team)
          question = create(:question)

          create(
            :answer,
            :correct,
            user: user,
            team: team,
            question: question
          )

          answer = create(
            :answer,
            :incorrect,
            user: user,
            team: team,
            question: question
          )

          changer = described_class.new(answer)

          expect { changer.change }.to_not change(EarnedScore, :count)
        end
      end

      context "when the user haven't already correct answered the question" do
        it "doesn't update the user score" do
          user = create(:user)
          team = create(:team)
          question = create(:question)

          answer = create(
            :answer,
            :incorrect,
            user: user,
            team: team,
            question: question
          )

          changer = described_class.new(answer)

          expect { changer.change }.to_not change(EarnedScore, :count)
        end
      end
    end
  end
end
