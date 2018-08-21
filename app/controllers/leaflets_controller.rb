class LeafletsController < ApplicationController

  before_action :guest_check, only: [:show]
  before_action :authenticate_user!, except: [:screen]
  before_action :set_room, only: [:show, :edit, :update, :destroy, :story_list, :user_list, :set_room_status, :draw_board, :switch_role, :summary, :invite, :sync_status]
  before_action :enter_room, only: [:show]
  protect_from_forgery except: :sync_status

  def new
    @room = Room.new
    @room.stories.build
  end

  def show

  end
end
