class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_exercise
  before_action :find_question, only: [:show, :edit, :update, :destroy]

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
      redirect_to [@exercise, @question]
    else
      render 'new'
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def edit
  end

  def update
    if @question.update_attributes(question_params)
      flash[:success] = "Questão atualizada!"
      redirect_to [@exercise, @question]
    else
      render 'edit'
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "Questão excluída!"
    redirect_to exercise_questions_url(@exercise)
  end

    private

    def question_params
      params.require(:question).permit(:description, :exercise_id)
    end

    def find_exercise
      @exercise = Exercise.find(params[:exercise_id])
    end

    def find_question
      @question = Question.find(params[:id])
    end
end
