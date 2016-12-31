class LearningObjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_learning_object, only: [:show, :edit, :update, :destroy]

  def index
    @learning_objects = LearningObject.where(user: current_user)
  end

  def show
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
      render 'new'
    end
  end

  def edit
  end

  def update
    if @learning_object.update_attributes(learning_object_params)
      flash[:success] = "Objeto de Aprendizagem atualizado!"
      redirect_to @learning_object
    else
      render 'edit'
    end
  end

  def destroy
    @learning_object.destroy
    flash[:success] = "Objeto de Aprendizagem deletado!"
    redirect_to learning_objects_url
  end

    private

    def learning_object_params
      params.require(:learning_object).permit(:title, :description, :available)
    end

    def find_learning_object
      @learning_object = LearningObject.find(params[:id])
    end
end
