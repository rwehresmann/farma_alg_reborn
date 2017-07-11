class AnswerConnectionsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!
  before_action :find_connection, only: [:show, :destroy]

  def show
    respond_to do |format|
      format.js { @link_html_id = params[:link_html_id] }
      format.html
    end
  end

  def destroy
    @connection.destroy

    Log.create!(operation: Log::EDGE_REJECT, user: current_user)

    respond_to do |format|
      format.js
      format.html do
        flash[:success] = "Relacionamento deletado!"
        redirect_to session[:previous_answer_url]
      end
    end
  end

    private

    def find_connection
      @connection = AnswerConnection.find(params[:id])
    end
end
