class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.integer :status
      t.string :subscription_id
      t.string :subscription_plan_id
      t.string :update_url
      t.string :cancel_url
      t.datetime :cancellation_effective_date

      t.timestamps
    end

    add_index :subscriptions, [:user_id, :status]
    add_index :subscriptions, :subscription_id
    add_index :subscriptions, :status
  end
end
