class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.string :type, null: false
      t.references :user
      t.timestamps
    end
  end
end
