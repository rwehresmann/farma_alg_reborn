FactoryGirl.define do
  sequence(:name) { |i| "Name_#{i}" }
	sequence(:email) { |i| "user_#{i}@mail.com" }
end
