class AddPointToStories < ActiveRecord::Migration
  def change
    add_column :stories, :point, :string
  end
end
