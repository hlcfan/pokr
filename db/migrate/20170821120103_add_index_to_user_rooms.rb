class AddIndexToUserRooms < ActiveRecord::Migration[5.1]
  def change
    add_index :user_rooms, :room_id
  end
end
