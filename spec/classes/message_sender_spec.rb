require 'rails_helper'

describe MessageSender do
  describe "#send" do
    context "when there aren't any inconsistence in the data to send" do
      it "sends all messages" do
        messages_count = Message.count
        sender = create(:user, :teacher)
        receivers = create_pair(:user)

        described_class.new(
          sender: sender,
          receivers: receivers,
          title: "Message title",
          content: "Message content"
        ).send

        expect(Message.count).to eq messages_count + 2
        expect(sender.messages_sended.count).to eq 2
        expect(receivers[0].messages_received.count).to eq 1
        expect(receivers[1].messages_received.count).to eq 1
      end
    end

    context "when something goes wrong sending a message" do
      subject {
        described_class.new(
          sender: create(:user, :teacher),
          receivers: [create(:user), nil],
          title: "Message title",
          content: "Message content"
        ).send
      }

      it "doesn't create any message" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Message.count).to eq 0
      end
    end
  end
end
