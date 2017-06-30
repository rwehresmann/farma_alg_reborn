class CreateUserScores < ActiveRecord::Migration[5.0]
  def change
    create_table :user_scores do |t|
      t.references :user
      t.references :team
      t.integer :score, null: false, default: 0
      t.integer :position
      t.integer :start_position_on_day
      t.timestamps
    end
  end
end
