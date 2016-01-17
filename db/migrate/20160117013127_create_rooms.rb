class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.integer :status

      t.timestamps null: false
    end
  end
end
