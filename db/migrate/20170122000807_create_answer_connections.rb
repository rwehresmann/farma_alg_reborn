class CreateAnswerConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_connections do |t|
      t.references :answer_1, references: :answer
      t.references :answer_2, references: :answer
      t.float :similarity, null: false
      t.timestamps
    end
  end
end
