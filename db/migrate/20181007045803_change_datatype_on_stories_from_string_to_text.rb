class ChangeDatatypeOnStoriesFromStringToText < ActiveRecord::Migration[5.2]
  def  up
    change_column :stories, :desc, :text
  end

  def down
    change_column :stories, :desc, :string
  end
end
