FactoryGirl.define do
  sequence(:name) { |i| "Name_#{i}" }
	sequence(:email) { |i| "user_#{SecureRandom.hex(5)}@mail.com" }
  sequence(:title) { |i| "Title_#{i}" }
end
