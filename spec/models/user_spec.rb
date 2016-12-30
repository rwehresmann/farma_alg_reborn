require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations -->" do
    let(:user) { build(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid with empty name" do
      user.name = ""
      expect(user).to_not be_valid
    end

    it "is invalid with empty password" do
      user.password = ""
      expect(user).to_not be_valid
    end

    it "is invalid with empty email" do
      user.email = ""
      expect(user).to_not be_valid
    end

    it "is valid with valid email addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                       first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |address|
        user.email = address
        expect(user).to be_valid
      end
    end

    it "is invalid with invalid email addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com user@example..com]
      invalid_addresses.each do |address|
        user.email = address
        expect(user).to_not be_valid
      end
    end

    it "doesn't accept duplicated e-mails" do
      user_aux = build(:user)
      user_aux.email = user.email
      user_aux.save
      expect(user).to_not be_valid
    end

    it "is invalid with empty teacher flag" do
      user.teacher = ""
      expect(user).to_not be_valid
    end

    it "is invalid with empty admin flag" do
      user.admin = ""
      expect(user).to_not be_valid
    end
  end

  describe "Relationships -->" do
    it "has many learning objects" do
      expect(relationship_type(User, :learning_objects)).to eq(:has_many)
    end
  end
end
