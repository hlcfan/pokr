class AddUidToSchemes < ActiveRecord::Migration[5.2]
  def change
    add_column :schemes, :uid, :string

    add_index :schemes, :uid, unique: true
  end
end
