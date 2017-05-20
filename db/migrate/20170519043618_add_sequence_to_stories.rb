class AddSequenceToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :sequence, :integer
  end
end
