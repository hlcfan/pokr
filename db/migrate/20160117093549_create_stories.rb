class CreateStories < ActiveRecord::Migration[4.2]
  def change
    create_table :stories do |t|
      t.integer :room_id
      t.string :link
      t.string :desc

      t.timestamps null: false
    end
  end
end
