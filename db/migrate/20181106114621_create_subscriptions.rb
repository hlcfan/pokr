class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.string :subscription_id
      t.string :subscription_plan_id
      t.string :update_url
      t.string :cancel_url

      t.timestamps
    end

    add_index :subscriptions, :user_id
    add_index :subscriptions, :subscription_id
  end
end
