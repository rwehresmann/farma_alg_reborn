require 'rails_helper'

RSpec.describe MessageActivity, type: :model do
  it "is valid with valid attributes" do
    expect(build(:message_activity)).to be_valid
  end

  it "is invalid without the sender" do
    message = build(:message_activity, sender: nil)
    expect(message).to_not be_valid
  end

  it "is invalid without the receiver" do
    message = build(:message_activity, receiver: nil)
    expect(message).to_not be_valid
  end

  describe "Relationships" do
    it "belongs to a sender" do
      expect(relationship_type(MessageActivity, :sender)).to eq(:belongs_to)
    end

    it "belongs to an receiver" do
      expect(relationship_type(MessageActivity, :receiver)).to eq(:belongs_to)
    end

    it "belongs to a message" do
      expect(relationship_type(MessageActivity, :message)).to eq(:belongs_to)      
    end
  end
end
