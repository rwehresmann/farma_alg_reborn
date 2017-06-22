class MessageSender
  def initialize(sender:, receivers:, content:, title:)
    @sender = sender
    @receivers = receivers
    @content = content
    @title = title
  end

  def send
    ActiveRecord::Base.transaction do
      @receivers.each do |user|
        @message = Message.create!(
          content: @content,
          title: @title,
          sender: @sender,
          receiver: user
        )
      end
    end
  end
end
