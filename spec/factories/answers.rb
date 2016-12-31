FactoryGirl.define do
  factory :answer do
    content "answer content"
    user
    question

    trait :correct do
      correct true
    end
  end
end
