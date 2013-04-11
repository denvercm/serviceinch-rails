class CreateTicketNotes < ActiveRecord::Migration
  def change
    create_table :ticket_notes do |t|
      t.integer :updated_by_id
      t.text :comments
      t.integer :ticket_id

      t.timestamps
    end
  end
end
