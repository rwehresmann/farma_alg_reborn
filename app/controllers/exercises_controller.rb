class ExercisesController < ApplicationController
  #load_and_authorize_resource

  before_action :authenticate_user!
  before_action :find_exercise, only: [:show, :edit, :update, :destroy]

  def index
    @exercises = Exercise.where(user: current_user)
  end

  def show
  end

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = current_user.exercises.build(exercise_params)
    if @exercise.save
      flash[:success] = "Exercício criado!"
      redirect_to @exercise
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @exercise.update_attributes(exercise_params)
      flash[:success] = "Exercício atualizado!"
      redirect_to @exercise
    else
      render 'edit'
    end
  end

  def destroy
    @exercise.destroy
    flash[:success] = "Exercício deletado!"
    redirect_to exercises_url
  end

    private

    def exercise_params
      params.require(:exercise).permit(:title, :description, :available)
    end

    def find_exercise
      @exercise = Exercise.find(params[:id])
    end
end
