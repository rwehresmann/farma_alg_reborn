class CreateExercisesTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises_teams do |t|
      t.references :exercise, :team

      t.timestamps null: false
    end
  end
end
