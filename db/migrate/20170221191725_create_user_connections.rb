class CreateUserConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :user_connections do |t|
      t.references :user_1, references: :answer
      t.references :user_2, references: :answer
      t.float :similarity, null: false
      t.timestamps
    end
  end
end
