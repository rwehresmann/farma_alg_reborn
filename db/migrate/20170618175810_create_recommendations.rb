class CreateRecommendations < ActiveRecord::Migration[5.0]
  def change
    create_table :recommendations do |t|
      t.references :team
      t.references :question
      t.integer :answers, array: true, default: []
      t.timestamps
    end
  end
end
