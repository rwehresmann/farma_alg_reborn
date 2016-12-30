class CreateLearningObjects < ActiveRecord::Migration[5.0]
  def change
    create_table :learning_objects do |t|
      t.string :title, null: false, unique: true
      t.string :description, null: false
      t.boolean :available, null: false, default: false
      t.references :user
      t.timestamps
    end
  end
end
