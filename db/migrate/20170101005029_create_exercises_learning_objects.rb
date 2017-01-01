class CreateExercisesLearningObjects < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises_learning_objects do |t|
      t.references :exercise, :learning_object
    end
  end
end
