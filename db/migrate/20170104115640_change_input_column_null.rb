class ChangeInputColumnNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :test_cases, :input, true
  end
end
