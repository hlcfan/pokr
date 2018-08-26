class AddCommentAndFinalizedToUserStoryPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :user_story_points, :comment, :text
    add_column :user_story_points, :finalized, :boolean

    add_index :user_story_points, :finalized
  end
end
