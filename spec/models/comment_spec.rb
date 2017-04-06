require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Validations -->" do
    let(:comment) { build(:comment) }

    it { expect(comment).to be_valid }

    it "is invalid with empty content" do
      comment.content = ""
      expect(comment).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it { expect(relationship_type(Comment, :answer)).to eq(:belongs_to) }
    it { expect(relationship_type(Comment, :user)).to eq(:belongs_to) }
  end
end
