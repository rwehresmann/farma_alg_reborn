class RecommendationsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    @recommendations = TeacherTeamsLastRecommendationsQuery
      .new(current_user)
      .call
      .paginate(
        page: params[:page],
        per_page: 15
      )
  end

  def show
    @recommendation = Recommendation.find(params[:id])
    @answers = Answer.find(@recommendation.answers)
  end
end
