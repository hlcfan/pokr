class RemoveDurationFromRooms < ActiveRecord::Migration[5.1]
  def change
    remove_column :rooms, :duration
  end
end
