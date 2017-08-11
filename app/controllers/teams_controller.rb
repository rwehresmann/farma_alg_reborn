class TeamsController < ApplicationController
  load_and_authorize_resource

  include AnswerObjectToGraph

  before_action :authenticate_user!

  def index
    @teams = params[:my_teams] ? current_user.teams_from_where_belongs :
                                TeamQuery.new.active_teams
    @teams = @teams.paginate(page: params[:page], per_page: 5)

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
      redirect_to teams_url
    else
      render 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])

    if @team.update_attributes(team_params)
      flash[:success] = "Turma atualizada!"
      redirect_to teams_url
    else
      render 'edit'
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = "Turma deletada!"
    redirect_to teams_url
  end

  def rankings
    @team = Team.find(params[:id])
    records_limit = @team.owner?(current_user) ? nil : 15

    records = UserScoreQuery.new.ranking(team: @team, limit: records_limit)
    @general_ranking = format_ranking(records)
    @general_base_score = @general_ranking.first[:score] unless records.empty?

    @weekly_ranking = EarnedScore.ranking(
      team: @team,
      starting_from: current_week_date,
      limit: records_limit
    )
    @weekly_base_score = @weekly_ranking.first[:score] unless @weekly_ranking.empty?

    if @team.enrolled?(current_user)
      @incentive_ranking = IncentiveRanking::Builder.new(
        target: current_user,
        team: @team,
        positions: { above: 1, below: 1 }
      ).build
      @current_user_index = current_user_index
    end

    render 'rankings'
  end

  def exercises
    @team = Team.find(params[:id])

    render 'exercises'
  end

  def users
    @team = Team.find(params[:id])

    render 'users'
  end

  def graph
    @team = Team.find(params[:id])

    render 'graph'
  end

  def enroll
    @team = Team.find(params[:id])

    if @team.authenticate(params[:password])
      @team.enroll(current_user)
      flash[:success] = "Matrícula realizada!"
      @enrolled = true
    else
      @enrolled = false
    end

    respond_to { |format| format.js }
  end

  def unenroll
    @team = Team.find(params[:id])
    @team.unenroll(current_user)
    flash[:success] = "Matrícula cancelada!"

    redirect_to teams_url
  end

  def list_questions
    @team = Team.find(params[:id])
    @exercise = Exercise.find(params[:exercise_id])
    @dependency_checker = DependencyChecker.new(
      exercise: @exercise,
      team: @team,
      user: current_user
    )
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

    Log.create!(operation: Log::ANSW_SEARCH, user: current_user)

    respond_to { |format|
      format.js { render "teams/graph/answers" }
    }
  end

  def add_or_remove_exercise
    @team = Team.find(params[:id])
    @exercise = Exercise.find(params[:exercise_id])

    @team.send("#{params[:operation]}_exercise", @exercise)

    respond_to { |format| format.js }
  end

  private

  def team_params
    params.require(:team).permit(:name, :active, :password, :password_confirmation)
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

  def current_user_index
    record = @incentive_ranking.select { |data| data[:user] == current_user }.first
    @incentive_ranking.index(record)
  end

  def split_date_range
    params[:date_range] ? params[:date_range].split("_") : []
  end
end
