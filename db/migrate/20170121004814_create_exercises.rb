class CreateExercises < ActiveRecord::Migration[5.0]
  def change
    create_table :exercises do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.references :user

      t.timestamps null: false
    end
  end
end
