class AddUserRoomsCountToRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :user_rooms_count, :integer
  end
end
