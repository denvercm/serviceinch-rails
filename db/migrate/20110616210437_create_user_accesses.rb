class CreateUserAccesses < ActiveRecord::Migration
  def change
    create_table :user_accesses do |t|
      t.string :comments
      t.boolean :can_create_ticket
      t.boolean :can_edit_customer

      t.timestamps
    end
  end
end
