FactoryGirl.define do
  factory :team do
    name
    password "foobar"
    association :owner, factory:  :user

    factory :team_with_students do
      transient do
        students_count 0
      end

      after(:create) do |user, evaluator|
        create_list(:team, evaluator.users_count, user: user)
      end
    end
  end
end
