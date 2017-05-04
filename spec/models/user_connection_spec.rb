require 'rails_helper'

RSpec.describe UserConnection, type: :model do
  describe "Validations -->" do
    let(:user_connection) { build(:user_connection) }

    it "is valid whit valid attributes" do
      expect(user_connection).to be_valid
    end

    it "is invalid without the similarity" do
      user_connection.similarity = ""
      expect(user_connection).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to two users" do
      expect(relationship_type(UserConnection, :user_1)).to eq(:belongs_to)
      expect(relationship_type(UserConnection, :user_2)).to eq(:belongs_to)
    end
  end
end
