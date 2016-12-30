class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :description, null: false
      t.references :exercise
      t.timestamps
    end
  end
end
