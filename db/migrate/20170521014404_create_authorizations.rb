class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations, id: :uuid do |t|
      t.uuid :user_id, index: true
      t.string :provider
      t.string :uid
      t.string :access_token

      t.timestamps
    end
  end
end
