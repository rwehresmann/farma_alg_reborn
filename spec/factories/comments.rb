FactoryGirl.define do
  factory :comment do
    user
    answer
    content "message content"
  end
end
