FactoryGirl.define do
  factory :message do
    title { |i| "Title of message #{i}" }
    content { |i| "Content of message #{i}" }

    before(:create) { |message|
      message_activity = create(:message_activity, message: message)
    }
  end
end
