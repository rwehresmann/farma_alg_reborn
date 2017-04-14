class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.string :content, null: false
      t.boolean :correct, default: false, null: false
      t.integer :attempt, null: false
      t.references :user, :question, :team

      t.timestamps null: false
    end
  end
end
