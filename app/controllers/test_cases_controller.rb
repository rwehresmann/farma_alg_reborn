class TestCasesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_test_case, only: [:show, :edit, :update, :destroy]
  before_action :find_question, only: [:index, :new, :create]

  def index
    @test_cases = TestCase.where(question: @question)
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

    private

    def test_case_params
      params.require(:test_case).permit(:description, :input, :output, :question_id)
    end

    def find_test_case
      @test_case = TestCase.find(params[:id])
    end

    def find_question
      @question = Question.find(params[:question_id])
    end
end
