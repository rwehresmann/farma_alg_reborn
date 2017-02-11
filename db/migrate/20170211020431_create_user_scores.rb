class CreateUserScores < ActiveRecord::Migration[5.0]
  def change
    create_table :user_scores do |t|
      t.references :user
      t.references :team
      t.integer :score, null: false, default: 0
      t.datetime :computed
      t.timestamps
    end
  end
end
