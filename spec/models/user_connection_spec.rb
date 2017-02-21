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

  describe ".similarity" do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:result) { UserConnection.similarity(user_1, user_2) }

    before { UserConnection.create!(user_1: user_1, user_2: user_2, similarity: 100) }

    it "returns the similarity of a connection" do
      expect(result).to eq(100)
    end
  end

  describe ".create_simetrical_record" do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:result_1) { UserConnection.similarity(user_1, user_2) }
    let(:result_2) { UserConnection.similarity(user_2, user_1) }

    before { UserConnection.create_simetrical_record(user_1, user_2, 100) }

    it "creates a simetrical record" do
      expect(result_1).to eq(100)
      expect(result_2).to eq(100)
    end
  end
end
