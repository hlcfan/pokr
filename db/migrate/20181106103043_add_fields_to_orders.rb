class AddFieldsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :coupon,          :string
    add_column :orders, :checkout_id,     :string
    add_column :orders, :payment_method,  :string
    add_column :orders, :receipt_url,     :string
    add_column :orders, :subscription_id, :string

    remove_column :orders, :payer_id

    add_index :orders, :payment_method
    add_index :orders, :subscription_id
  end
end
