require 'rails_helper'

describe UserLastAnswersQuery do
  context "when there are answers" do
    it "returns the last answers" do
      user = create(:user)
      create_list(:answer, described_class::ANSWERS_NUMBER + 1, user: user)

      result = described_class.new(user).call

      expect(result.count).to eq described_class::ANSWERS_NUMBER
    end
  end

  context "when there aren't answers" do
    it "returns an empty array" do
      result = described_class.new(create(:user)).call

      expect(result).to eq []
    end
  end
end
