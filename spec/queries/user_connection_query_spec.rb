require 'rails_helper'

describe UserConnectionQuery do
  describe '#similarity' do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let!(:user_connection_1) { create(:user_connection, similarity: 10) }
    let!(:user_connection_2) {
      create(:user_connection, user_1: user_1, user_2: user_2, similarity: 100)
    }

    subject { described_class.new.similarity(user_1: user_1, user_2: user_2).first }

    it { expect(subject.similarity).to eq(user_connection_2.similarity) }
  end
end
