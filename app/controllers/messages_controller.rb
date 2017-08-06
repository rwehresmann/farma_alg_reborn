class MessagesController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    message_type = params[:sended] ? "messages_sended" : "messages_received"
    @messages = current_user.send(message_type)
      .order(created_at: :desc)
      .paginate(
        page: params[:page],
        per_page: 15
      )
  end

  def new
    @message = Message.new
    @message.content = links_to_markdown
    @question = Answer.find_by(id: params[:answer_ids].first).question if params[:answer_ids]
    previous_message = Message.find_by(id: params[:previous_message_id])

    if previous_message
      @message.content += markdown_quote_message(previous_message)
      @message.title = previous_message.title
    end
    @receivers = build_receivers_array
    @log = params[:log]
  end

  def create
    @message = Message.new(message_params)
    @receivers = build_receivers_array
    @question = Question.find_by(id: params[:question_id])

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

      Log.create!(operation: Log::MSG_SEND, user: current_user)
      Log.create!(operation: params[:log], user: current_user, question: @question) unless params[:log].blank? || params[:log].nil?

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
