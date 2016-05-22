class AlterUserRoom < ActiveRecord::Migration
  def change
    change_column :user_rooms, :user_id, :integer, :null => false
    change_column :user_rooms, :room_id, :integer, :null => false
  end
end
