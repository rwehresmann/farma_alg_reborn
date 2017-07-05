class RecommendationsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  def index
    @recommendations = Recommendation.all
      .order(created_at: :desc)
      .paginate(
        page: params[:page],
        per_page: 15
      )
  end

  def show
    @recommendation = Recommendation.find(params[:id])
  end
end
