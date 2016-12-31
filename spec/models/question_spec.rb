require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "Validations -->" do
    let(:question) { build(:question) }

    it "is valid with valid attributes" do
      expect(question).to be_valid
    end
  end

  describe "Relationships -->" do
    it "belongs to exercise" do
      expect(relationship_type(Question, :exercise))
    end
  end
end
