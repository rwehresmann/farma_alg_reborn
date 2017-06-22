FactoryGirl.define do
  factory :message do
    sender { create(:user) }
    receiver { create(:user) }
    title "message title"
    content "message content"
  end
end
