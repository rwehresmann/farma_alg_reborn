FactoryGirl.define do
  factory :exercise do
    title
    description "exercise description"
    user

    factory :exercise_with_questions do
      transient do
        questions_count 0
      end

      after(:create) do |exercise, evaluator|
        create_list(:question, evaluator.questions_count, exercise: exercise)
      end
    end
  end
end
