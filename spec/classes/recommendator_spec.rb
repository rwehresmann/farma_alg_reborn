require 'rails_helper'

describe Recommendator do
  describe "#search_and_create_recommendations" do
    context "when there are recommendations to be created" do
      it do
        exercise = create(:exercise)
        questions = create_list(:question, 6, exercise: exercise)
        users = create_pair(:user)
        team = create(:team, exercises: [exercise], users: users)

        answers = []
        questions.each { |question|
          users.each { |user|
            answers << create(
              :answer,
              team: team,
              user: user,
              question: question
            )
          }
        }

        create(
          :user_connection,
          user_1: users[0],
          user_2: users[1],
          team: team,
          similarity: Figaro.env.similarity_threshold.to_f
        )

        create(
          :answer_connection,
          answer_1: answers[2],
          answer_2: answers[3],
          similarity: Figaro.env.similarity_threshold.to_f + 1
        )

        create(
          :answer_connection,
          answer_1: answers[4],
          answer_2: answers[5],
          similarity: Figaro.env.similarity_threshold.to_f - 1
        )

        create(
          :answer_connection,
          answer_1: answers[6],
          answer_2: answers[7],
          similarity: Figaro.env.similarity_threshold.to_f - 1
        )

        described_class.new(team).search_and_create_recommendations
      end
    end

    context "when there aren't recommendations to be created" do

    end
  end
end
