FactoryGirl.define do
  factory :message do
    sender { create(:user) }
    title "message title"
    content "message content"
  end
end
