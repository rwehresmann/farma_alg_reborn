require 'rails_helper'
require 'utils/similarity_machine/users_similarities'

describe SimilarityMachine::UsersSimilarities do
  describe '#more_similar' do
    context "when limiting the number of results to return" do
      it "returns the results respecting the similarity threshold and the limit specified" do
        users = create_list(:user, 3)
        teams = create_pair(:team, users: users)

        set_common_sample_data(users, teams)

        users_similarities = described_class.new(teams[0]).more_similar
        expected_result = [
          [users[0], 170],
          [users[2], 100],
          [users[1], 70]
        ]

        expect(users_similarities).to eq expected_result
      end
    end

    context "without limiting the number of results to return" do
      it "returns the results respecting the similarity threshold" do
        users = create_list(:user, 3)
        teams = create_pair(:team, users: users)

        set_common_sample_data(users, teams)

        users_similarities = described_class.new(teams[0]).more_similar(1)
        expected_result = [ [users[0], 170] ]

        expect(users_similarities).to eq expected_result
      end
    end
  end

  def set_common_sample_data(users, teams)
    create(
      :user_connection,
      user_1: users[0],
      user_2: users[1],
      team: teams[0],
      similarity: 70
    )
    create(
      :user_connection,
      user_1: users[0],
      user_2: users[2],
      team: teams[0],
      similarity: 100
    )

    # This connection must be avoided >>

    create(
      :user_connection,
      user_1: users[0],
      user_2: users[1],
      team: teams[1],
      similarity: 30
    )
  end
end
