FactoryGirl.define do
  factory :message do
    title { |i| "Title of message #{i}" }
    content { |i| "Content of message #{i}" }
  end
end
