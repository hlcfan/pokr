class ChangeSlugToNotNullable < ActiveRecord::Migration
  def change
    change_column :rooms, :slug, :string, :null => false
  end
end
