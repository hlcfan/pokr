class AddPointValuesToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :pv, :string
  end
end
