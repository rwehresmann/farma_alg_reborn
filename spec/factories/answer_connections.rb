FactoryGirl.define do
  factory :answer_connection do
    association :answer_1, factory: :answer
    association :answer_2, factory: :answer
    similarity 5.0

    trait :high_similarity do
      similarity 9.0
    end

    trait :low_similarity do
      similarity 1.0
    end
  end
end
