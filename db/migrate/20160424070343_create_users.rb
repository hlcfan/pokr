class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.integer :role

      t.timestamps null: false
    end
  end
end
