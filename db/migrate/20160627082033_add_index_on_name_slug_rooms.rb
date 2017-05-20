class AddIndexOnNameSlugRooms < ActiveRecord::Migration[4.2]
  def change
    add_index :rooms, :name
    add_index :rooms, :slug, unique: true
  end
end
