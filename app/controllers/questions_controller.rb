class QuestionsController < ApplicationController
  def index
    @exercise = Exercise.find(params[:exercise_id])
    @questions = Question.where(exercise: @exercise)
  end

  def new
  end

  def create
  end
end
