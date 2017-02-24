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

    context "when the similarity need to be caught from the simetrical record" do
      before { AnswerConnection.create!(answer_1: answer_2, answer_2: answer_1, similarity: 100) }

      it "returns the correct similarity" do
        expect(result).to eq(100)
      end
    end
  end

  describe ".by_threshold" do
    let(:connection_1) { create(:answer_connection, similarity: 100) }
    let(:connection_2) { create(:answer_connection, similarity: 90) }
    let(:connection_3) { create(:answer_connection, similarity: 80) }

    context "when answers are specified" do
      it "returns the connections that belongs to these answers" do
        answers = (connection_1.answers + connection_2.answers)
        received = described_class.by_threshold(100, answers).to_a
        expect(received).to eq([connection_1])
      end
    end

    context "when answers aren't specified" do
      it "searches in all connections" do
        received = described_class.by_threshold(80)
        expect(received).to eq([connection_1, connection_2, connection_3])
      end
    end

    context "when doesn't exists connections bigger or equal the threshold" do
      it "returns an empty result" do
        received = described_class.by_threshold(101)
        expect(received.empty?).to be_truthy
      end
    end
  end

  describe '#answers' do
    let(:connection) { create(:answer_connection) }

    it "returns the answers from the connection" do
      expected = [connection.answer_1, connection.answer_2]
      expect(connection.answers).to eq(expected)
    end
  end
end
