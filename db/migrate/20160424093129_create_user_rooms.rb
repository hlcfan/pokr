class CreateUserRooms < ActiveRecord::Migration
  def change
    create_table :user_rooms do |t|
      t.integer :user_id
      t.integer :room_id

      t.timestamps null: false
    end

    add_index :user_rooms, [:user_id, :room_id], unique: true
  end
end
