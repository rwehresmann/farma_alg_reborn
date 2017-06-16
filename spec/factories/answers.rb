FactoryGirl.define do
  factory :answer do
    content File.open("spec/support/files/hello_world.pas").read
    user
    question
    team
    attempt 1

    after(:build) do |answer|
      class << answer
        def set_correct; end
      end
    end

    trait :whit_custom_callbacks do
      after(:build) do |answer|
        class << answer
          def set_correct; super; end
        end
      end
    end

    trait :correct do
      correct true
    end

    trait :incorrect do
      correct false
    end

    trait :invalid_content do
      content "This string doesn't compile as a code"
    end

    trait :hello_world do
      content File.open("spec/support/files/hello_world.pas").read
    end

    trait :hello_world_2 do
      content File.open("spec/support/files/hello_world_2.pas").read
    end

    trait :ola_mundo do
      content File.open("spec/support/files/ola_mundo.pas").read
    end

    trait :params do
      content File.open("spec/support/files/params.pas").read
    end
  end
end
