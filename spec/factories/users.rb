FactoryGirl.define do
  factory :user do
    name
    email
    password "foobar"

    trait :teacher do
      teacher true
    end

    trait :admin do
      admin true
    end
  end
end
