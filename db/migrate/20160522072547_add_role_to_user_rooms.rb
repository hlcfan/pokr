class AddRoleToUserRooms < ActiveRecord::Migration[4.2]
  def change
    add_column :user_rooms, :role, :integer
  end
end
