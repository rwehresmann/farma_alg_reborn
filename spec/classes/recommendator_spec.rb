require 'rails_helper'

describe Recommendator do
  context "when there are recommendations to be created" do
    context "when recommendation doesn't exists already" do
      it "creates it" do
        exercise = create(:exercise)
        question = create(:question, exercise: exercise)
        team = create(:team, exercises: [exercise])
        answers = create_list(:answer, 8, team: team, question: question)

        create(
          :answer_connection,
          answer_1: answers[0],
          answer_2: answers[1],
          similarity: Figaro.env.similarity_threshold.to_f
        )

        create(
          :answer_connection,
          answer_1: answers[0],
          answer_2: answers[2],
          similarity: Figaro.env.similarity_threshold.to_f
        )

        create(
          :answer_connection,
          answer_1: answers[0],
          answer_2: answers[3],
          similarity: Figaro.env.similarity_threshold.to_f + 1
        )

        create(
          :answer_connection,
          answer_1: answers[4],
          answer_2: answers[5],
          similarity: Figaro.env.similarity_threshold.to_f + 1
        )

        create(
          :answer_connection,
          answer_1: answers[6],
          answer_2: answers[7],
          similarity: Figaro.env.similarity_threshold.to_f - 1
        )

        described_class.new(team).search_and_create_recommendations

        expect(Recommendation.count).to eq 2
        expect(Recommendation.first.answers.count).to eq 4
        expect(Recommendation.first.answers).to include(*answers.first(4).map(&:id))
        expect(Recommendation.second.answers.count).to eq 2
        expect(Recommendation.second.answers).to include(*answers[4..5].map(&:id))
      end
    end

    context "when recommendations already exists" do
      it "doesn't creates it" do
        exercise = create(:exercise)
        question = create(:question, exercise: exercise)
        team = create(:team, exercises: [exercise])
        answers = create_pair(:answer, team: team, question: question)

        create(
          :recommendation,
          team: team,
          question: question,
          answers: answers.map(&:id)
        )

        create(
          :answer_connection,
          answer_1: answers[0],
          answer_2: answers[1],
          similarity: Figaro.env.similarity_threshold.to_f
        )

        expect {
          described_class.new(team).search_and_create_recommendations
        }.to_not change(Recommendation, :count)
      end
    end
  end

  context "when there aren't recomendations to be created" do
    it "doesn't create any recommendation" do
      exercise = create(:exercise)
      question = create(:question, exercise: exercise)
      team = create(:team, exercises: [exercise])
      answers = create_pair(:answer, team: team, question: question)

      expect {
        described_class.new(team).search_and_create_recommendations
      }.to_not change(Recommendation, :count)
    end
  end
end
