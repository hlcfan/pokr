class AddNullableFalseToUidField < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :uid, :string, null: false
    change_column :stories, :uid, :string, null: false
    change_column :user_rooms, :uid, :string, null: false
    change_column :user_story_points, :uid, :string, null: false
    change_column :schemes, :uid, :string, null: false
    change_column :rooms, :uid, :string, null: false
  end

  def down
    change_column :users, :uid, :string
    change_column :stories, :uid, :string
    change_column :user_rooms, :uid, :string
    change_column :user_story_points, :uid, :string
    change_column :schemes, :uid, :string
    change_column :rooms, :uid, :string
  end
end
