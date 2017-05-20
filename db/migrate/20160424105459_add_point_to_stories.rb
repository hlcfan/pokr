class AddPointToStories < ActiveRecord::Migration[4.2]
  def change
    add_column :stories, :point, :string
  end
end
