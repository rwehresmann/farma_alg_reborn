require 'rails_helper'

RSpec.describe Message, type: :model do
  it "is valid with valid attributes" do
    expect(build(:message)).to be_valid
  end

  it "is invalid without the sender" do
    message = build(:message, sender: nil)
    expect(message).to_not be_valid
  end

  it "is invalid without the receiver" do
    message = build(:message, receiver: nil)
    expect(message).to_not be_valid
  end

  it "is invalid without title" do
    message = build(:message, title: "")
    expect(message).to_not be_valid
  end

  it "is invalid without content" do
    message = build(:message, content: "")
    expect(message).to_not be_valid
  end

  describe "Relationships" do
    it { expect(relationship_type(Message, :sender)).to eq(:belongs_to) }

    it { expect(relationship_type(Message, :receiver)).to eq(:belongs_to) }
  end

  describe "#create!" do
    it "adds at the beggining of the content sender informations" do
      message = create(:message)
      datetime = Time.now.strftime(Message::DATETIME_MASK)
      first_line = message.content.each_line.first

      expect(first_line).to match "#{message.sender.name}"
      expect(first_line).to match "#{message.receiver.name}"
      expect(first_line).to match "#{datetime}"
    end
  end
end
