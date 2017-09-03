class CreateTeamExercises < ActiveRecord::Migration[5.0]
  def self.up
    create_table :team_exercises do |t|
      t.references :team
      t.references :exercise
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    
    execute "insert into team_exercises(team_id, exercise_id, created_at, updated_at) select team_id, exercise_id, created_at, updated_at from exercises_teams;"
  
    drop_table :exercises_teams
  end
  
  def self.down
    rename_table :team_exercises, :exercises_teams
  end
end
