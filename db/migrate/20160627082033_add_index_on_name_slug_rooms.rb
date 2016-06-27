class AddIndexOnNameSlugRooms < ActiveRecord::Migration
  def change
    add_index :rooms, :name
    add_index :rooms, :slug, unique: true
  end
end
