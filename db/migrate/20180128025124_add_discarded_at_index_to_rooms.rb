class AddDiscardedAtIndexToRooms < ActiveRecord::Migration[5.1]
  def change
    add_index :rooms, :discarded_at
  end
end
