class ChangeSlugToNotNullable < ActiveRecord::Migration[4.2]
  def change
    change_column :rooms, :slug, :string, :null => false
  end
end
