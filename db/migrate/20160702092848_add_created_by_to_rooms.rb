class AddCreatedByToRooms < ActiveRecord::Migration[4.2]
  def change
    add_column :rooms, :created_by, :integer
    add_index :rooms, :created_by
  end
end
