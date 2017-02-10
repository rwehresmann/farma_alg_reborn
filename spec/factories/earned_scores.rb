FactoryGirl.define do
  factory :earned_score do
    user
    question
    team
    score 10
  end
end
