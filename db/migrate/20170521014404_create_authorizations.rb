class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
      t.integer :user_id, index: true
      t.string :provider
      t.string :uid
      t.string :access_token

      t.timestamps
    end
  end
end
