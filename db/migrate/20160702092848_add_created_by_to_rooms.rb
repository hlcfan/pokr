class AddCreatedByToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :created_by, :integer
    add_index :rooms, :created_by
  end
end
