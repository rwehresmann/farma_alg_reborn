class AddTeacherToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :teacher, :boolean
  end
end
