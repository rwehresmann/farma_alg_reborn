class CreateQuestionDependencies < ActiveRecord::Migration[5.0]
  def change
    create_table :question_dependencies do |t|
      t.references :question_1, references: :question
      t.references :question_2, references: :question
      t.string :operator, default: ""

      t.timestamps null: false
    end
  end
end
