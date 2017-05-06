require 'utils/incentive_ranking/builder'

class TeamsController < ApplicationController
  load_and_authorize_resource

  include AnswerObjectToGraph

  before_action :authenticate_user!
  before_action :find_team, only: [:enroll, :unenroll, :show, :edit, :update,
                                   :destroy, :add_or_remove_exercise]
  before_action :find_exercise, only: [:add_or_remove_exercise]
  before_action :find_exercises, only: [:show]

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
    records = UserScoreQuery.new.ranking(team: @team, limit: 5)
    set_general_ranking_data(records)
    set_weekly_ranking_data(records)
    set_incentive_ranking_data if @team.enrolled?(current_user)
    @enrolled_users = @team.users
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

  def list_questions
    @exercise = Exercise.find(params[:exercise_id])
  end

  def answers
    date_range = split_date_range
    answers = Answer.by_team(params[:id]).by_user(params[:users])
                    .by_question(params[:questions])
                    .between_dates(date_range[0], date_range[1])
                    .by_key_words(params[:key_words])

    @answers = answers.each.inject([]) { |array, answer|
                 array << answer_object_to_graph(answer)
              }

    respond_to { |format| format.js { render "teams/graph/answers" } }
  end

  def add_or_remove_exercise
    @team.send("#{params[:operation]}_exercise", @exercise)
    find_exercises

    respond_to { |format| format.js }
  end

    private

    def team_params
      params.require(:team).permit(:name, :active, :password, :password_confirmation)
    end

    # Return all teams or only the user teams.
    def find_teams
      teams = params[:my_teams] ? current_user.teams_from_where_belongs :
                                  Team.active_teams
      teams.paginate(page: params[:page], per_page: 5)
    end

    def find_team
      @team = Team.find(params[:id])
    end

    def find_exercise
      @exercise = Exercise.find(params[:exercise_id])
    end

    def find_exercises
      @team_exercises = @team.exercises
      @teacher_exercises = current_user.exercises
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
      @weekly_ranking = EarnedScore.ranking(team: @team,
                                              starting_from: current_week_date,
                                              limit: 5)
      @weekly_base_score = @weekly_ranking.first[:score] unless @weekly_ranking.empty?
    end

    def set_incentive_ranking_data
      @incentive_ranking = IncentiveRanking::Builder.new(
        target: current_user,
        team: @team,
        positions: { above: 1, below: 1 }
      ).build
      @current_user_index = current_user_index
    end

    def current_user_index
      record = @incentive_ranking.select { |data| data[:user] == current_user }.first
      @incentive_ranking.index(record)
    end

    def split_date_range
      params[:date_range] ? params[:date_range].split("_") : []
    end
end
