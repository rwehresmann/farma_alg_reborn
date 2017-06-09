class DashboardController < ApplicationController
  before_action :authenticate_user!

  def home
    if current_user.teacher?
      @teams_answers = TeacherTeamsLastAnswersQuery.new(teacher: current_user).call
      # @recommendations =
    end

  end

end
