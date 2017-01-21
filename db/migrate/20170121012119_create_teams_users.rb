class CreateTeamsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :teams_users do |t|
      t.references :team, :user
      t.timestamps null: false
    end
  end
end
