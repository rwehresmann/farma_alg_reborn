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

  describe '#answers' do
    let(:connection) { create(:answer_connection) }

    it "returns the answers from the connection" do
      expected = [connection.answer_1, connection.answer_2]
      expect(connection.answers).to eq(expected)
    end
  end

  describe '#same_user?' do
    subject { answer_connection.same_user? }

    context "when both answers belongs to the same user" do
      let(:user) { create(:user) }
      let(:answer_1) { create(:answer, user: user) }
      let(:answer_2) { create(:answer, user: user) }
      let(:answer_connection) { create(:answer_connection,
                                          answer_1: answer_1,
                                          answer_2: answer_2) }

      it { expect(subject).to be_truthy }
    end

    context "when answers are from different users" do
      let(:answer_connection) { create(:answer_connection) }

      it { expect(subject).to be_falsey }
    end
  end
end
