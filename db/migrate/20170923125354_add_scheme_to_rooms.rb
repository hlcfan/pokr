class AddSchemeToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :scheme, :string
  end
end
