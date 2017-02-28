class AnswersController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :find_question

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    # If content is empty the form submition is invalid and we doesn't need
    # to save the try.
    if params[:answer][:content]
      @answer.save
      @results = @answer.results
    end

    respond_to { |format| format.js }
  end

    private

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
end
