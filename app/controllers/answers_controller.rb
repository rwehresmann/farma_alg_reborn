class AnswersController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:show, :connections]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save unless @answer.content.empty?
    @results = @answer.results

    respond_to { |format| format.js { render 'shared/test_answer' } }
  end

  def show
    respond_to { |format| format.js }
  end

  def connections
    connections = @answer.connections_with(params[:answers])

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
      params.require(:answer).permit(:content)
    end

    def find_question
      @question = Question.find(params[:id])
    end

    # Get answer data used in views.
    def answer_data(answer)
      answer.slice(:id, :content, :correct, :compilation_error,
                               :compiler_output, :created_at).symbolize_keys
    end

    # Get user data used in views.
    def user_data(user)
      user.slice(:id, :name).symbolize_keys
    end

    # Get exercise data used in views.
    def exercise_data(exercise)
      exercise.slice(:id, :title).symbolize_keys
    end

    # Get question data used in views.
    def question_data(question)
      question.slice(:id, :title).symbolize_keys
    end

    # Create a hash with the necessary data to display in the graph.
    def answer_object_to_graph(answer)
      hash = {}
      hash.merge!(answer_data(answer))
      hash[:user] = user_data(answer.user)
      hash[:question] = question_data(answer.question)
      hash[:exercise] = exercise_data(answer.question.exercise)
      hash
    end
end
