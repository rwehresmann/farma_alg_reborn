FactoryGirl.define do
  factory :answer do
    content File.open("spec/support/files/hello_world.pas").read
    user
    question
    team

    after(:build) do |answer|
      class << answer
        def check_answer; end
        def save_results; end
      end
    end

    trait :whit_custom_callbacks do
      after(:build) do |answer|
        class << answer
          def check_answer; super; end
          def save_results; super; end
        end
      end
    end

    trait :correct do
      correct true
      compilation_error false
    end

    trait :whit_compilation_error do
      correct false
      compilation_error false
    end

    trait :whit_compilation_error do
      correct false
      compilation_error false
    end

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
