class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.string :ip
      t.string :express_token
      t.string :express_payer_id
      t.timestamps
    end

    add_index :orders, :user_id
  end
end
