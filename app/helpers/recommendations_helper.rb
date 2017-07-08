module RecommendationsHelper
  def ids_from_recommendation_users
    @answers.map { |answer| answer.user.id }.uniq
  end
end
