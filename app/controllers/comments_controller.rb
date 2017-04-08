class CommentsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!
  before_action :find_comment, only: [:update, :destroy]

  def create
    @answer = Answer.find(params[:answer_id])
    @comment = @answer.comments.create(comment_params.merge(user: current_user))

    respond_to { |format| format.js }
  end

  def update
    @answer = @comment.answer

    if @comment.update_attributes(comment_params)
      @comments = @answer.comments
      @new_comment = Comment.new
    end

    respond_to { |format| format.js }
  end

  def destroy
    @comment.destroy

    respond_to { |format| format.js }
  end

    private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def find_comment
      @comment = Comment.find(params[:id])
    end
end
