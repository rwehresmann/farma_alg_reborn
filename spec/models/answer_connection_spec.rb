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
end
