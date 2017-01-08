class Team < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :password
  validates_inclusion_of :active, in: [true, false]

  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_and_belongs_to_many :users
end
