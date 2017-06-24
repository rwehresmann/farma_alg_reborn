class DashboardController < ApplicationController
  before_action :authenticate_user!

  def home
    @teams_answers = TeacherTeamsLastAnswersQuery.new(teacher: current_user).call if current_user.teacher?
    @user_answers = UserLastAnswersQuery.new(current_user).call
    @user_last_messages = current_user.messages_received
      .order(created_at: :desc)
      .limit(5)
  end

end
