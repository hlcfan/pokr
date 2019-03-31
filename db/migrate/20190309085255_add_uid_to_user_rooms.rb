class AddUidToUserRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :user_rooms, :uid, :string

    add_index :user_rooms, :uid, unique: true
  end
end
