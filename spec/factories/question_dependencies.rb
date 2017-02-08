FactoryGirl.define do
  factory :question_dependency do
    operator QuestionDependency::DEPENDENCIES.first
    association :question_1, factory: :question
    association :question_2, factory: :question
  end
end
