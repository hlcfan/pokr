class CreateSchemes < ActiveRecord::Migration[5.2]
  def change
    create_table :schemes do |t|
      t.string :name, null: false
      t.string :points, array: true, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
