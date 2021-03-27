class CreateRooms < ActiveRecord::Migration[4.2]
  def change
    create_table :rooms, id: :uuid do |t|
      t.string :name, null: false
      t.integer :status

      t.timestamps null: false
    end
  end
end
