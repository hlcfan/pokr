class CreateRetroSchemes < ActiveRecord::Migration[6.0]
  def change
    create_table :retro_schemes do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.string :uid, null: false
      t.string :col_1
      t.string :col_2
      t.string :col_3
      t.string :col_4
      t.string :col_5

      t.timestamps
    end

    add_index :retro_schemes, :uid
    add_index :retro_schemes, :user_id
    add_index :retro_schemes, :col_1
    add_index :retro_schemes, :col_2
    add_index :retro_schemes, :col_3
    add_index :retro_schemes, :col_4
    add_index :retro_schemes, :col_5
  end
end
