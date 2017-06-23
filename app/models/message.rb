class Message < ApplicationRecord
  DATETIME_MASK = "%H:%M:%S - %d/%m/%Y"

  validates_presence_of :title, :content

  belongs_to :sender, class_name: :User
  belongs_to :receiver, class_name: :User

  before_save :add_sender_information

  private

  def add_sender_information
    info = "<sup>**Enviada por #{sender.name} (sender.email) para #{receiver.name} (#{receiver.email}) às #{Time.now.strftime(DATETIME_MASK)}**</sup>\n\n"
    self.content.prepend(info)
  end
end
