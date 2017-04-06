class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :answer
      t.references :user
      t.text :content, null: false
      t.timestamps
    end
  end
end
