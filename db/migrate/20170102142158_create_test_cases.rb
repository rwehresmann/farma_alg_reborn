class CreateTestCases < ActiveRecord::Migration[5.0]
  def change
    create_table :test_cases do |t|
      t.string :description
      t.string :input, null: false
      t.string :output, null: false
      t.references :question

      t.timestamps
    end
  end
end
