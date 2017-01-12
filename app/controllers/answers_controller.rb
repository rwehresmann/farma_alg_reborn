class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def new
    @answer = Answer.new
  end

  def create
  end

    private

    def find_question
      @question = Question.find(params[:id])
    end
end
