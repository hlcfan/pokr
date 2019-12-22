class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :text
      t.integer :user_id, null: false
      t.string :uid, null: false
      t.integer :retro_id, null: false
      t.integer :retro_scheme_id, null: false
      t.string :retro_scheme_col_id, null: false

      t.timestamps
    end

    add_index :notes, :retro_id
  end
end
