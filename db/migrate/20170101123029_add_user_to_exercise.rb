class AddUserToExercise < ActiveRecord::Migration[5.0]
  def change
    add_reference :exercises, :user
  end
end
