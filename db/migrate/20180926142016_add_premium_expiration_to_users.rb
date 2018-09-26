class AddPremiumExpirationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :premium_expiration, :datetime
  end
end
