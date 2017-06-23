class MessagesController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    @messages_sended = current_user.messages_sended
    @messages_received = current_user.messages_received
  end

  def new
    @message = Message.new
    @message.content = links_to_markdown
    previous_message = Message.find_by(id: params[:previous_message_id])
    if previous_message
      @message.content += markdown_quote_message(previous_message)
      @message.title = previous_message.title
    end
    @receivers = build_receivers_array
  end

  def create
    @message = Message.new(message_params)
    @receivers = build_receivers_array

    if @message.title.empty? || @message.content.empty?
      flash[:danger] = "Por favor forneça um titúlo e conteúdo para mensagem!"
      render "new"
    elsif @receivers.empty?
      flash[:danger] = "Sem destinatários para enviar a mensagem."
      render "new"
    else
      MessageSender.new(
        sender: current_user,
        receivers: @receivers,
        content: @message.content,
        title: @message.title
      ).send

      flash[:success] = "Mensagem enviada ao(s) destinatário(s)!"
      redirect_to messages_url
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  private

  def build_receivers_array
    user_ids = params[:receiver_ids]
    user_ids.nil? ? [] : user_ids.map { |user_id| User.find(user_id) }
  end

  def message_params
    params.require(:message).permit(:content, :title)
  end

  def links_to_markdown
    content = ""
    answer_ids = params[:answer_ids]
    answer_ids.nil? ? [] : answer_ids.each_with_index do |answer_id, index|
      answer = Answer.find(answer_id)
      content += "[Link para resposta #{index + 1}](#{answer_as_raw_url(answer)})\n\n"
    end

    content
  end

  def markdown_quote_message(message)
    "\n\n\n" + message.content.each_line.inject("") { |str, line| str += "> #{line}" }
  end
end
