class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :password, null: false
      t.string :name, null: false
      t.boolean :active, null: false, default: true
      t.references :user
      t.references :owner, references: :user
      t.timestamps
    end
  end
end
