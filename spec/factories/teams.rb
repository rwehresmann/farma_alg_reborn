FactoryGirl.define do
  factory :team do
    name
    password "foobar"
    association :owner, factory:  :user
  end
end
