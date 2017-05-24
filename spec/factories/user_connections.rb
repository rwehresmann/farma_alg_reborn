FactoryGirl.define do
  factory :user_connection do
    association :user_1, factory: :user
    association :user_2, factory: :user
    team
    similarity 5.0

    trait :high_similarity do
      similarity 9.0
    end

    trait :low_similarity do
      similarity 1.0
    end
  end
end
