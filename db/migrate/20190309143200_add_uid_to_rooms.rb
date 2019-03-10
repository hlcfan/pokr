class AddUidToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :uid, :string

    add_index :rooms, :uid, unique: true
  end
end