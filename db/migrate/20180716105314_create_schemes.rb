class CreateSchemes < ActiveRecord::Migration[5.2]
  def change
    create_table :schemes, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :points, array: true, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end

    add_index :schemes, :slug, unique: true
    add_index :schemes, :user_id
  end
end
