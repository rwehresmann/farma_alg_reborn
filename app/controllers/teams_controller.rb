class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @teams = find_teams

    respond_to do |format|
      format.html
      format.js
    end
  end

    private

    # Return all teams or only the user teams.
    def find_teams
      return current_user.my_teams if params[:my_teams]
      Team.active_teams
    end
end
