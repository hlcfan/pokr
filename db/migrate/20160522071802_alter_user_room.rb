class AlterUserRoom < ActiveRecord::Migration[4.2]
  def change
    change_column :user_rooms, :user_id, :uuid, :null => false
    change_column :user_rooms, :room_id, :uuid, :null => false
  end
end
