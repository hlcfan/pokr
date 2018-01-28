class AddDiscardedAtToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :discarded_at, :datetime
  end
end
