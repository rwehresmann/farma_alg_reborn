class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:show, :edit, :update, :destroy, :answer]
  before_action :find_exercise, only: [:index, :new, :create]

  def index
    @questions = Question.where(exercise: @exercise)
  end

  def new
    @question = Question.new
  end

  def create
    @question = @exercise.questions.build(question_params)
    if @question.save
      flash[:success] = "Questão criada e adicionada ao exercício!"
      redirect_to @question
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @question.update_attributes(question_params)
      flash[:success] = "Questão atualizada!"
      redirect_to @question
    else
      render 'edit'
    end
  end

  def destroy
    exercise = @question.exercise
    @question.destroy
    flash[:success] = "Questão excluída!"
    redirect_to exercise_questions_url(exercise)
  end

  def answer
  end

    private

    def question_params
      params.require(:question).permit(:description, :exercise_id)
    end

    def find_question
      @question = Question.find(params[:id])
    end

    def find_exercise
      @exercise = Exercise.find(params[:exercise_id])
    end
end
