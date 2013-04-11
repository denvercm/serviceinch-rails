class CreateTicketCategories < ActiveRecord::Migration
  def change
    create_table :ticket_categories do |t|
      t.string :name
      t.string :comments

      t.timestamps
    end
  end
end
