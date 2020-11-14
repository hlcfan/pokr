class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :uid
      t.string :name, null: false
      t.integer :created_by
      t.integer :status

      t.timestamps
    end

    add_foreign_key :organizations, :users, column: :created_by, primary_key: "id"

    add_index :organizations, :uid, unique: true
  end
end
