class AnswerConnectionsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!
  before_action :find_connection, only: [:show, :destroy]

  def show
    @link_html_id = params[:link_html_id]

    respond_to { |format| format.js }
  end

  def destroy
    @connection.destroy

    respond_to { |format| format.js }
  end

    private

    def find_connection
      @connection = AnswerConnection.find(params[:id])
    end
end
