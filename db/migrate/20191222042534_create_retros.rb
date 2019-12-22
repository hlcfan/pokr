class CreateRetros < ActiveRecord::Migration[6.0]
  def change
    create_table :retros do |t|
      t.string :name, null: false
      t.integer :created_by, null: false
      t.string :uid, null: false
      t.integer :retro_scheme_id, null: false

      t.timestamps
    end

    add_index :retros, :uid
    add_index :retros, :created_by
  end
end
