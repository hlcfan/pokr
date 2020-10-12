require 'rails_helper'

RSpec.describe Team, type: :model do
  describe "Associations" do
    it "has many user_teams" do
      expect(Team.reflect_on_association(:user_teams).macro).to eq(:has_many)
    end

    xit "has many teams" do
      expect(Team.reflect_on_association(:teams).macro).to eq(:has_many)
    end
  end

  describe ".for_user" do
    it "returns all teams with members for specific user" do
      user1 = User.create(email: 'a@a.com', password: 'password')
      user2 = User.create(email: 'b@b.com', password: 'password')
      user3 = User.create(email: 'c@c.com', password: 'password')

      team1 = Team.create(name: "team A")
      team2 = Team.create(name: "team B")

      UserTeam.create([
        {user_id: user1.id, team_id: team1.id},
        {user_id: user2.id, team_id: team1.id},
        {user_id: user3.id, team_id: team1.id},

        {user_id: user1.id, team_id: team2.id},
        {user_id: user3.id, team_id: team2.id}
      ])

      users = Team.find_by_user(user1)
      team_a_members = users["team A"].collect { |u| u.id }
      team_b_members = users["team B"].collect { |u| u.id }

      expect(team_a_members).to eq([user1.id, user2.id, user3.id])
      expect(team_b_members).to eq([user1.id, user3.id])
    end
  end
end
