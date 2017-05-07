require 'rails_helper'

describe AnswerConnectionQuery do
  describe '#connections_by_threshold' do
    let!(:connection_1) { create(:answer_connection, similarity: 100) }
    let!(:connection_2) { create(:answer_connection, similarity: 90) }
    let!(:connection_3) { create(:answer_connection, similarity: 80) }
    let!(:connection_4) { create(:answer_connection, similarity: 70) }

    context "when only max threshold is informed" do
      subject { described_class.new.connections_by_threshold(max: 90) }

      it { is_expected.to eq([connection_2, connection_3, connection_4]) }
    end

    context "when only min threshold is informed" do
      subject { described_class.new.connections_by_threshold(min: 90) }

      it { is_expected.to eq([connection_1, connection_2]) }
    end

    context "when max and min threshold are informed" do
      subject { described_class.new.connections_by_threshold(min: 70, max: 90) }

      it { is_expected.to eq([connection_2, connection_3, connection_4]) }
    end
  end

  describe '#get_similarity' do
    let(:similarity) { 76 }
    let(:answer_1) { create(:answer) }
    let(:answer_2) { create(:answer) }
    let!(:connection) {
      create(:answer_connection, answer_1: answer_1, answer_2: answer_2,
        similarity: similarity)
    }

    it { expect(similarity_result(answer_1, answer_2)).to eq(similarity) }

    it "returns the right similarity even inverting the answers order" do
      expect(similarity_result(answer_2, answer_1)).to eq(similarity)
    end
  end

  describe '#connections_group' do
    let(:team) { create(:team) }
    let(:answers) { create_list(:answer, 4, team: team) }
    let!(:connection_1) {
      create(:answer_connection, answer_1: answers[0], answer_2: answers[1]) }
    let!(:connection_2) {
      create(:answer_connection, answer_1: answers[0], answer_2: answers[2]) }
    let!(:connection_3) {
      create(:answer_connection, answer_1: answers[1], answer_2: answers[2]) }
    let!(:connection_4) {
      create(:answer_connection, answer_1: answers[3]) }

    # Connection who should not return.
    before { create(:answer_connection) }


    context "when type is 'between'" do
      subject { described_class.new.connections_group(answers: answers.first(3)) }

      it "returns connections between these answers" do
        expected = [connection_1, connection_2, connection_3]
        is_expected.to eq(expected)
      end
    end

    context "when type is 'with'" do
      subject { described_class.new.connections_group(answers: answers) }

      it "returns connections with these answers" do
        expected = [connection_1, connection_2, connection_3, connection_4]
        is_expected.to eq(expected)
      end
    end
  end

  private

  def similarity_result(answer_1, answer_2)
    described_class.new.get_similarity(answer_1, answer_2).first.similarity
  end
end
