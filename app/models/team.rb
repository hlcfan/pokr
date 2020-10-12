class Team < ApplicationRecord
  include UidGeneration

  has_many :user_teams
  has_many :users, through: :user_teams

  def self.find_by_user current_user
    team_ids = current_user.teams.pluck(:id)

    User
      .left_joins(:teams)
      .left_joins(:user_teams)
      .where("teams.id in (?)", team_ids)
      .select(:id, :uid, :email, :name, :image)
      .select("teams.name as team_name")
      .select("teams.uid as team_uid")
      .order("user_teams.created_at")
      .group_by {|u| u.attributes["team_name"]}
      .inject({}) do |h, (team_name, members)|
      h[team_name] = members.uniq
      h
    end
  end
end
