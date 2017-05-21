class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :access_token

      t.timestamps
    end
  end
end
