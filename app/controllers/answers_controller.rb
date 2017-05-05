class AnswersController < ApplicationController
  include AnswerObjectToGraph
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: [:show]
  before_action :save_answer_url, only: [:show]

  def new
    @answer = Answer.new
    @team = Team.find(params[:team_id])
    @correct_answer = AnswerQuery.user_last_correct_answer_from_team(
      team: @team, user: current_user, question: @question
    )
    flash.now[:info] = "Você já respondeu corretamenta esta questão. Sinta-se a
                       vontade para realizar novas tentativas, mas a partir de
                       agora, elas não incrementarão seu score nem surtirão
                       qualquer efeito sobre o score desta questão." if @correct_answer
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answer.save unless @answer.content.empty?
    @results = @answer.results

    respond_to { |format| format.js { render 'shared/test_answer' } }
  end

  def show
    respond_to do |format|
      format.html do
        @similar_answers = @answer.similar_answers(threshold: 10)
        @comments = @answer.comments
        @comment = Comment.new
      end
      format.js { @node_html_id = params[:node_html_id] }
    end
  end

  def connections
    connections = AnswerConnection.connections(params[:answers],
                                               params[:type].to_sym)

    @connections = connections.each.inject([]) do |array, connection|
      hash = {}
      hash.merge!(connection.slice(:id, :similarity).symbolize_keys)

      connection.slice(:answer_1, :answer_2).each do |answer|
        answer_key = answer[0].to_sym
        answer_obj = answer[1]
        hash[answer_key] = answer_object_to_graph(answer_obj)
      end

      array << hash
    end

    respond_to { |format| format.json { render json: @connections } }
  end


    private

    def find_answer
      @answer = Answer.find(params[:id])
    end

    def correct?(results)
      results.each { |result| return false if result[:status] == :error }
      true
    end

    def answer_params
      params.require(:answer).permit(:content, :team_id)
    end

    def find_question
      @question = Question.find(params[:id])
    end

    # Add answer url in sessions to be used in a redirect when an answer
    # connection is deleted.
    def save_answer_url
      session[:previous_answer_url] = answer_url(@answer)
    end
end
