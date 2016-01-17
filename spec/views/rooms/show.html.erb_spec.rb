require 'rails_helper'

RSpec.describe "rooms/show", type: :view do
  before(:each) do
    @room = assign(:room, Room.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
