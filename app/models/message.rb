class Message < ApplicationRecord
  validates_presence_of :title, :content
  validates_inclusion_of :read, in: [true, false]
end
