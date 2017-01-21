FactoryGirl.define do
  factory :answer do
    content File.open("spec/support/files/hello_world.pas").read
    user
    question
    team

    trait :invalid_content do
      content "This string doesn't compile as a code"
    end

    trait :ola_mundo do
      content File.open("spec/support/files/ola_mundo.pas").read
    end

    trait :params do
      content File.open("spec/support/files/params.pas").read
    end

    trait :compilation_error do
      content File.open("spec/support/files/hello_world_compilation_error.pas").read
    end
  end
end
