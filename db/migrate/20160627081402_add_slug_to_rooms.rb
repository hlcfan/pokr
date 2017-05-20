class AddSlugToRooms < ActiveRecord::Migration[4.2]
  def change
    add_column :rooms, :slug, :string
  end
end
