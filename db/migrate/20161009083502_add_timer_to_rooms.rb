class AddTimerToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :timer, :float
  end
end
