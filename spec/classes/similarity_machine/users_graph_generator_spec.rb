require 'rails_helper'

describe SimilarityMachine::UsersGraphGenerator do
  describe '#generate' do
    context "when there are users connections computed in the team" do
      it "returns the similarities greather or equal the similarity threshold" do
        users = create_list(:user, 3)
        teams = create_pair(:team, users: users)

        create(
          :user_connection,
          user_1: users[0],
          user_2: users[1],
          team: teams[0],
          similarity: Figaro.env.similarity_threshold.to_f + 1
        )

        create(
          :user_connection,
          user_1: users[0],
          user_2: users[2],
          team: teams[0],
          similarity: Figaro.env.similarity_threshold.to_f
        )

        # These connections must be ignored >>

        create(
          :user_connection,
          user_1: users[1],
          user_2: users[2],
          team: teams[0],
          similarity: Figaro.env.similarity_threshold.to_f - 1
        )

        create(
          :user_connection,
          user_1: users[0],
          user_2: users[1],
          team: teams[1],
          similarity: Figaro.env.similarity_threshold.to_f + 1
        )

        graph = described_class.new(teams[0]).generate

        expect(graph.count).to eq 2
      end
    end

    context "when there aren't users connections computed in the team" do
      it "returns an empty array" do
        graph = described_class.new(create(:team)).generate
        expect(graph).to eq []
      end
    end
  end
end
