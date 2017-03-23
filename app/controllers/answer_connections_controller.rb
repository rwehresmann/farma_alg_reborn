class AnswerConnectionsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def show
    @connection = AnswerConnection.find(params[:id])
    @link_html_id = params[:link_html_id]

    respond_to { |format| format.js }
  end
end
