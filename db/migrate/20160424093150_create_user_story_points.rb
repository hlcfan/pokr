class CreateUserStoryPoints < ActiveRecord::Migration[4.2]
  def change
    create_table :user_story_points, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :story_id
      t.string :points

      t.timestamps null: false
    end

    add_index :user_story_points, [:user_id, :story_id], unique: true
  end
end
