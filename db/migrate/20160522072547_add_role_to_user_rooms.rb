class AddRoleToUserRooms < ActiveRecord::Migration
  def change
    add_column :user_rooms, :role, :integer
  end
end
