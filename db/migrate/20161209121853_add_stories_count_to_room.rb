class AddStoriesCountToRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :stories_count, :integer
  end
end
