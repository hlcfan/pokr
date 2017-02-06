class AddStyleToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :style, :integer
  end
end
