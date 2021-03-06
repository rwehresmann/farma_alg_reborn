FactoryGirl.define do
  factory :question do
    title "question title"
    description "question description"
    exercise
    score 10
    operation "task"

    trait :challenge do
      operation "challenge"
    end

    transient do
      test_cases_count 0
    end

    # Through evaluator we access the transient counter, and say that
    # we would like to create test_cases (create_list 1st argument) that
    # belongs to the question created above (create_list 3th argument).
    after(:create) do |question, evaluator|
      create_list(:test_case, evaluator.test_cases_count, question: question)
    end
  end
end
