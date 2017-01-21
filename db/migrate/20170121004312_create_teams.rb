class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :password_digest, null: false
      t.string :name, null: false
      t.boolean :active, default: true, null: false
      t.references :owner, references: :user

      t.timestamps null: false
    end
  end
end
