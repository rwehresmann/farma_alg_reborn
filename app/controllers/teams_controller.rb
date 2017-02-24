class TeamsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!
  before_action :find_team, only: [:enroll, :unenroll, :show, :edit, :update, :destroy]

  def index
    @teams = find_teams

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams_created.build(team_params)
    if @team.save
      flash[:success] =  "Turma criada!"
      redirect_to @team
    else
      render 'new'
    end
  end

  def show
    @exercises = @team.exercises
    records = UserScore.rank(team: @team, limit: 5)
    set_general_ranking_data(records)
    set_weekly_ranking_data(records)
    set_incentive_ranking_data if @team.enrolled?(current_user)
  end

  def edit
  end

  def update
    if @team.update_attributes(team_params)
      flash[:success] = "Turma atualizada!"
      redirect_to @team
    else
      render 'edit'
    end
  end

  def destroy
    @team.destroy
    flash[:success] = "Turma deletada!"
    redirect_to teams_url
  end

  def enroll
    if @team.authenticate(params[:password])
      @team.enroll(current_user)
      flash[:success] = "Matrícula realizada!"
      @enrolled = true
    else
      @enrolled = false
    end

    respond_to do |format|
      format.js
    end
  end

  def unenroll
    @team.unenroll(current_user)
    flash[:success] = "Matrícula cancelada!"
    redirect_to teams_url
  end

    private

    def team_params
      params.require(:team).permit(:name, :active, :password, :password_confirmation)
    end

    # Return all teams or only the user teams.
    def find_teams
      return current_user.my_teams if params[:my_teams]
      Team.active_teams
    end

    def find_team
      @team = Team.find(params[:id])
    end

    # Format to an array of hashes, where the first key is the user object, and
    # the second is the score (this format is needed to use in the ranking
    # partial, shared with the weekly ranking).
    def format_ranking(records)
      records.map.inject([]) { |array, obj| array << { user: obj.user, score: obj.score } }
    end

    def current_week_date
      Date.today.at_beginning_of_week
    end

    def set_general_ranking_data(records)
      @general_ranking = format_ranking(records)
      @general_base_score = @general_ranking.first[:score] unless records.empty?
    end

    def set_weekly_ranking_data(records)
      @weekly_ranking = EarnedScore.rank_user(team: @team,
                                              starting_from: current_week_date,
                                              limit: 5)
      @weekly_base_score = @weekly_ranking.first[:score] unless @weekly_ranking.empty?
    end

    def set_incentive_ranking_data
      limits = { downto: 1, upto: 1, answers: 5 }
      @incentive_ranking = current_user.incentive_ranking(@team, limits)
      @current_user_index = current_user_index
    end

    def current_user_index
      record = @incentive_ranking.select { |data| data[:user] == current_user }.first
      @incentive_ranking.index(record)
    end
end
