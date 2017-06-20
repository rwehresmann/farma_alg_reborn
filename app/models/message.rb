class Message < ApplicationRecord
  validates_presence_of :title, :content

  belongs_to :sender, class_name: :User
  has_many :receivers, class_name: :User
end
