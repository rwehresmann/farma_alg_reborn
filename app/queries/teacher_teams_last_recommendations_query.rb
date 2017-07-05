class TeacherTeamsLastRecommendationsQuery
  NUMBER_OF_RECOMMENDATIONS = 5
  def initialize(teacher)
    @teacher = teacher
  end

  def call
    Recommendation.where(team_id: Team.select(:id).where(owner: @teacher))
      .order(created_at: :desc)
      .limit(NUMBER_OF_RECOMMENDATIONS)
  end
end
