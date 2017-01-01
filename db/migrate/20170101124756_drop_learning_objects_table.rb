class DropLearningObjectsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :learning_objects
  end
end
