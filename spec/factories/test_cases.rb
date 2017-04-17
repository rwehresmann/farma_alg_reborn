FactoryGirl.define do
  factory :test_case do
    title
    output "output"
    question

    trait :hello_world do
      output "Hello, world.\n"
    end

    trait :hello_world_2 do
      output "Hello world!\n"
    end
  end
end
