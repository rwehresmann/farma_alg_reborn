require 'rails_helper'

describe UserConnectionQuery do
  describe '#similarity_in_team' do
    context "when similarity already exists" do
      it "returns the right similarity" do
        users = create_pair(:user)
        team = create(:team)

        create(
          :user_connection,
          user_1: users[0],
          user_2: users[1],
          team: team,
          similarity: 76
        )

        result = described_class.new.similarity_in_team(
          user_1: users[1],
          user_2: users[0],
          team: team
        )

        expect(result).to eq 76
      end
    end

    context "when similarity doesn't exists already" do
      it "returns nil" do
        users = create_pair(:user)

        result = described_class.new.similarity_in_team(
          user_1: users[1],
          user_2: users[0],
          team: create(:team)
        )

        expect(result).to be_nil
      end
    end
  end
end
