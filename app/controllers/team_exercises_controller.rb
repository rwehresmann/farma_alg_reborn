class TeamExercisesController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!
  
  def create
    team_exercise = TeamExercise.create(team_exercise_params)
    @team = team_exercise.team
    @exercise = team_exercise.exercise
    render "exercises_list"
  end
  
  def update
    team_exercise = find_team_exercise
    find_team_exercise.update_attributes(active: !team_exercise.active)
  end
  
  def destroy
    team_exercise = find_team_exercise
    @team = team_exercise.team
    @exercise = team_exercise.exercise
    team_exercise.destroy
    
    render "exercises_list"
  end
  
  private
  
  def find_team_exercise
    TeamExercise.find(params[:id])
  end
  
  def team_exercise_params
    params.require(:team_exercise).permit(:team_id, :exercise_id, :active)
  end
end
