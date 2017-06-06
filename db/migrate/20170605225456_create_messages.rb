class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.string :content, null: false
      t.boolean :read, null: false, default: false
      t.timestamps
    end
  end
end
