FactoryGirl.define do
  factory :message_activity do
    sender { create(:user) }
    receiver { create(:user) }
    message
  end
end
