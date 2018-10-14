class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :name
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :user_id, null: false
      t.string :ip
      t.string :payment_id
      t.string :payer_id
      t.integer :status
      t.string :currency
      t.integer :quantity
      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :payment_id
  end
end
