class LearningObjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @learning_objects = LearningObject.where(user: current_user)
  end

  def show
    @learning_object = LearningObject.find(params[:id])
  end

  def new
    @learning_object = LearningObject.new
  end

  def create
    @learning_object = current_user.learning_objects.build(learning_object_params)
    if @learning_object.save
      flash[:success] = "Objeto de Aprendizagem criado!"
      redirect_to @learning_object
    else
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

    private

    def learning_object_params
      params.require(:learning_object).permit(:title, :description, :available)
    end
end
