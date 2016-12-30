class CreateExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.references :learning_object_id
      t.timestamps
    end
  end
end
