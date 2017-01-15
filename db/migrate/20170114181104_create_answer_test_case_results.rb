class CreateAnswerTestCaseResults < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_test_case_results do |t|
      t.references :answer, :test_case
      t.string :output, null: false
      t.timestamps
    end
  end
end
