class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.references :sender, references: :User
      t.references :receiver, references: :User
      t.timestamps
    end
  end
end
