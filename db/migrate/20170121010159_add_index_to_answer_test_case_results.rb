class AddIndexToAnswerTestCaseResults < ActiveRecord::Migration[5.0]
  def change
    add_index :answer_test_case_results, [:answer_id, :test_case_id], unique: true
  end
end
