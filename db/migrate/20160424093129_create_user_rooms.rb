class CreateUserRooms < ActiveRecord::Migration[4.2]
  def change
    create_table :user_rooms, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :room_id

      t.timestamps null: false
    end

    add_index :user_rooms, [:user_id, :room_id], unique: true
  end
end
