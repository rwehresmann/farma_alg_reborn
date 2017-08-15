class AddMainClassNameToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :main_class_name, :string, null: false, default: ""
  end
end
