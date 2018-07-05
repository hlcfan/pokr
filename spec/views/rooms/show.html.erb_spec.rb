require 'rails_helper'

RSpec.describe "rooms/show", type: :view do
  login_user

  before(:each) do
    @room = assign(:room, Room.create!(
      :name => "Name"
    ))

    user = User.find_by(email: 'a@a.com')
    UserRoom.create(user_id: user.id, room_id: @room.id)
    Rails.cache.delete "user_room:#{user.id}:#{@room.id}"
  end

  it "renders attributes in <p>" do
    controller.extra_params = { :id => 111 }

    render
    expect(rendered).to match(/Name/)
  end
end
