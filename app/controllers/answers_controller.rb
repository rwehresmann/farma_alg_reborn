class AnswersController < ApplicationController
  include AnswerObjectToGraph
  include AnswerLanguageExtension
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: [:show, :show_as_raw, :log]
  before_action :save_answer_url, only: [:show]

  def index
    date_range = split_date_range

    unless params[:correct].blank?
      correct = params[:correct] == "true" ? true : false
    else
      correct = nil
    end

    @answers = Answer
      .where(user: current_user)
      .by_team(params[:teams])
      .by_question(params[:questions])
      .between_dates(date_range[0], date_range[1])
      .correct_status(correct)
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 15)
  end

  def new
    @answer = Answer.new
    @answer.lang_extension = answer_language_extension(@question)
    @team = Team.find(params[:team_id])

    selected_answer = Answer.find_by(id: params[:answer_id])
    @content =  ""
    @results = []

    if selected_answer
      Log.create!(
        operation: Log::ANSW_SHOW,
        user: current_user,
        question: selected_answer.question
      )

      @content = selected_answer.content

      results = AnswerTestCaseResult.where(answer: selected_answer)
      @results = []
      results.each { |result|
        @results << {
          test_case: result.test_case,
          correct: selected_answer.correct,
          output: result.output
        }
      }
    end

    if !@team || @team.exercises.include?(@question.exercise)
      @submitable = true

      flash.now[:info] = "Você já respondeu corretamenta esta questão. Sinta-se a
        vontade para realizar novas tentativas, mas a partir de agora, elas não
        incrementarão seu score nem surtirão qualquer efeito sobre o score desta
        questão." if @question.answered_by_user?(
          current_user,
          team: @team,
          only_correct: true
        )
    else
      @submitable = false

      flash.now[:info] = "O exercício dessa questão não esta mais disponível para ser respondido."
    end
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answer.lang_extension = answer_language_extension(@question)
    creator = AnswerCreator::Creator.new(@answer)
    creator.create unless @answer.content.empty?
    @results = creator.test_cases_results

    respond_to { |format| format.js { render 'shared/test_answer' } }
  end

  def show
    Log.create!(operation: Log::ANSW_SHOW, user: current_user, question: @answer.question)
    @question = @answer.question

    respond_to do |format|
      format.html {
        @similar_answers = @answer.similar_answers(
          threshold: Figaro.env.similarity_threshold.to_f
        )
      }
      format.js { @node_html_id = params[:node_html_id] }
    end
  end

  def show_as_raw
    Log.create!(operation: Log::ANSW_SHOW, user: current_user, question: @answer.question)
    render layout: false
  end

  def connections
    connections = AnswerConnectionQuery.new.connections_group(
      answers: params[:answers], type: params[:type].to_sym)

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

  def log
    Log.create!(operation: Log::ANSW_SHOW, user: current_user, question: @answer.question)
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

  def split_date_range
    params[:date_range] ? params[:date_range].split("_") : []
  end
end
