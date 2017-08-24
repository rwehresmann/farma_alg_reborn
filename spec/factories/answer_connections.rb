FactoryGirl.define do
  factory :answer_connection do
    association :answer_1, factory: :answer
    association :answer_2, factory: :answer
    similarity 100

    trait :high_similarity do
      similarity 90
    end

    trait :low_similarity do
      similarity 10
    end
  end
end
