class AddPointValuesToRooms < ActiveRecord::Migration[4.2]
  def change
    add_column :rooms, :pv, :string
  end
end
