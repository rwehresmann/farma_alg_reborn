require 'rails_helper'

describe AnswerQuery do
  describe '#user_last_correct_answer' do
    let(:user) { create(:user) }

    context "when filter by team" do
      it "returns the last correct answer from the team" do
        teams = create_pair(:team)
        user = create(:user)

        answer = create(
          :answer,
          :correct,
          team: teams[0],
          user: user,
          created_at: Time.now + 1.day
        )

        # These records must be avoided >>

        create(:answer, :correct, team: teams[0], user: user)
        create(:answer, :correct, team: teams[1], user: user)
        create(:answer, :correct, team: teams[0])

        result = described_class.new.user_last_correct_answer(
          user,
          to: { team: teams[0] }
        ).first

        expect(result).to eq answer
      end
    end

    context "when filtered by question" do
      it "returns the last correct answer from the question" do
        questions = create_pair(:question)
        user = create(:user)

        answer = create(
          :answer,
          :correct,
          question: questions[0],
          user: user,
          created_at: Time.now + 1.day
        )

        # These records must be avoided >>

        create(:answer, :correct, question: questions[0], user: user)
        create(:answer, :correct, question: questions[1], user: user)
        create(:answer, :correct, question: questions[0])

        result = described_class.new.user_last_correct_answer(
          user,
          to: { question: questions[0] }
        ).first

        expect(result).to eq answer
      end
    end
  end

  describe '#answers_to_compare' do
    it "returns all answers from the informed answer team and question, except itself" do
      team = create(:team)
      question = create(:question)
      answers = create_list(:answer, 3, question: question, team: team)

      result = described_class.new.answers_to_compare(answers.first)

      expect(result).to eq answers.last(2)
    end
  end
end
