class AddUserIdToUserAccess < ActiveRecord::Migration
  def change
    add_column :user_accesses, :user_id, :integer
  end
end