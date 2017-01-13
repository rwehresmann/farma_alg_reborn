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
    @results = @question.test_all(plain_current_datetime, "pas", params[:content])
    @answer.correct = correct?(@results)
    if @answer.save
      if @answer.correct?
        flash.now[:success] = "Resposta correta!"
      else
        flash.now[:danger] = "Resposta incorreta!"
      end
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
