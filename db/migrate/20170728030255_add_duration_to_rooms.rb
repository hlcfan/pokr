class AddDurationToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :duration, :float
  end
end
