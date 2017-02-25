class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :operation, null: false, default: "task"
      t.float :score, null: false
      t.references :exercise

      t.timestamps null: false
    end
  end
end
