class CreateUserStoryPoints < ActiveRecord::Migration
  def change
    create_table :user_story_points do |t|
      t.integer :user_id
      t.integer :story_id
      t.string :points

      t.timestamps null: false
    end

    add_index :user_story_points, [:user_id, :story_id], unique: true
  end
end
