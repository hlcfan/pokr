class AddUidToUserStoryPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :user_story_points, :uid, :string

    add_index :user_story_points, :uid, unique: true
  end
end
