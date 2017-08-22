class AddIndexToUserStoryPoints < ActiveRecord::Migration[5.1]
  def change
    add_index :user_story_points, :story_id
  end
end
