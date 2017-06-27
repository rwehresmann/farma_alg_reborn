class CreateTestCases < ActiveRecord::Migration[5.0]
  def change
    create_table :test_cases do |t|
      t.string :title, null: false
      t.string :description
      t.string :inputs
      t.string :output, null: false
      t.references :question
      t.timestamps null: false
    end
  end
end
