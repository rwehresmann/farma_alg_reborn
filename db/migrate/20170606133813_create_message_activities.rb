class CreateMessageActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :message_activities do |t|
      t.references :sender, references: :User
      t.references :receiver, references: :User
      t.references :message
      t.timestamps
    end
  end
end
