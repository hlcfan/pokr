class CreateUserOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_organizations do |t|
      t.string :uid
      t.integer :user_id, null: false
      t.integer :organization_id, null: false
      t.integer :role

      t.timestamps
    end

    add_foreign_key :user_organizations, :users
    add_foreign_key :user_organizations, :organizations

    add_index :user_organizations, [:organization_id, :user_id], unique: true
    add_index :user_organizations, :uid, unique: true
  end
end
