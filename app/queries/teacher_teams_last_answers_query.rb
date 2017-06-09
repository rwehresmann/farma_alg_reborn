class TeacherTeamsLastAnswersQuery
  NUMBER_OF_ANSWERS = 10

  def initialize(teacher:)
    @teacher = teacher
  end

  def call
    Answer.where(team_id: Team.select(:id).where(owner: @teacher))
      .order(created_at: :desc)
      .limit(NUMBER_OF_ANSWERS)
  end
end
