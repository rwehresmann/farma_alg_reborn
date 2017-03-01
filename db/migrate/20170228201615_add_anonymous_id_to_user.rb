class AddAnonymousIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :anonymous_id, :string
  end
end
