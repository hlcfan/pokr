require 'rails_helper'

RSpec.describe "rooms/new", type: :view do
  before(:each) do
    assign(:room, Room.new(
      :name => "MyString"
    ))
  end

  it "renders new room form" do
    render

    assert_select "form[action=?][method=?]", rooms_path, "post" do

      assert_select "input#room_name[name=?]", "room[name]"
    end
  end
end
