require 'rails_helper'

RSpec.describe AnswerConnection, type: :model do
  describe "Validations -->" do
    let(:answer_connection) { build(:answer_connection) }

    it "is valid whit valid attributes" do
      expect(answer_connection).to be_valid
    end

    it "is invalid without the similarity" do
      answer_connection.similarity = ""
      expect(answer_connection).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to two answers" do
      expect(relationship_type(AnswerConnection, :answer_1)).to eq(:belongs_to)
      expect(relationship_type(AnswerConnection, :answer_2)).to eq(:belongs_to)
    end
  end

  describe ".similarity" do
    let(:answer_1) { create(:answer) }
    let(:answer_2) { create(:answer) }
    let(:result) { AnswerConnection.similarity(answer_1, answer_2) }

    before { AnswerConnection.create!(answer_1: answer_1, answer_2: answer_2, similarity: 100) }

    it "returns the similarity of a connection" do
      expect(result).to eq(100)
    end
  end

  describe ".create_simetrical_record" do
    let(:answer_1) { create(:answer) }
    let(:answer_2) { create(:answer) }
    let(:result_1) { AnswerConnection.similarity(answer_1, answer_2) }
    let(:result_2) { AnswerConnection.similarity(answer_2, answer_1) }

    before { AnswerConnection.create_simetrical_record(answer_1, answer_2, 100) }

    it "creates a simetrical record" do
      expect(result_1).to eq(100)
      expect(result_2).to eq(100)
    end
  end
end
