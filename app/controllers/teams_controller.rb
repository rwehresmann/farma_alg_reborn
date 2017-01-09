class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team, only: [:enroll]

  def index
    @teams = find_teams

    respond_to do |format|
      format.html
      format.js
    end
  end

  def enroll
    if @team.authenticate(params[:password])
      @team.enroll(current_user)
      @enrolled = true
    else
      @enrolled = false
    end

    respond_to do |format|
      format.js
    end
  end

    private

    # Return all teams or only the user teams.
    def find_teams
      return current_user.my_teams if params[:my_teams]
      Team.active_teams
    end

    def find_team
      @team = Team.find(params[:id])
    end
end
