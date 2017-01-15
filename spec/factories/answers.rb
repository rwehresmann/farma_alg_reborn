FactoryGirl.define do
  factory :answer do
    content File.open("spec/support/files/hello_world.pas").read
    user
    question

    trait :invalid_content do
      content "This string doesn't compile as a code"
    end
  end
end
