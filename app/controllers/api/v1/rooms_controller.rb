module Api
  module V1
    class RoomsController < ActionController::API
      include ActionView::Rendering

      before_action :authenticate_user!
      before_action :set_room, only: [:show]

      def index
        @rooms = UserPresenter.new(current_user).participated_rooms
      end

      def show
        @stories = @room.groomed_stories.inject({}) do |hash, story|
          hash[story[1]] = { point: story[2] }
          hash
        end
      end

      private

      def set_room
        @room = Room.find_by(slug: params[:id])
        raise ActiveRecord::RecordNotFound if @room.nil?
      end
    end
  end
end
