class AddUidToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :uid, :string

    add_index :stories, :uid, unique: true
  end
end
