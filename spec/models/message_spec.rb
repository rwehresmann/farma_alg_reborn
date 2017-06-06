require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "Relationships" do
    it "has one message activity" do
      expect(relationship_type(Message, :message_activity)).to eq(:has_one)
    end
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(build(:message)).to be_valid
    end

    it "is invalid without title" do
      message = build(:message, title: "")
      expect(message).to_not be_valid
    end

    it "is innvalid without content" do
      message = build(:message, content: "")
      expect(message).to_not be_valid
    end

    it "is invalid without read flag" do
      message = build(:message, read: nil)
      expect(message).to_not be_valid
    end

    it "haves read as false by default" do
      message = build(:message)
      expect(message.read).to be_falsey
    end
  end
end
