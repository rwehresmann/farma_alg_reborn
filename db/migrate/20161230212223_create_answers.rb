class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.string :content, null: false
      t.boolean :correct, null: false
      t.references :user, :question
      t.timestamps
    end
  end
end
