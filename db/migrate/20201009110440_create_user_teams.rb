class CreateUserTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :user_teams do |t|
      t.references :user, null:false, foreign_key: true
      t.references :team, null:false, foreign_key: true

      t.timestamps
    end

    add_index :user_teams, [:user_id, :team_id], unique: true
  end
end
