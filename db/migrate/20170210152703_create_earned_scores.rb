class CreateEarnedScores < ActiveRecord::Migration[5.0]
  def change
    create_table :earned_scores do |t|
      t.references :user
      t.references :team
      t.references :question
      t.integer :score
      t.timestamps
    end
  end
end
