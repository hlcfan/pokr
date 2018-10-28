module Api
  module V1
    class RoomsController < ActionController::API
      include ActionView::Rendering

      def index
        @rooms = UserPresenter.new(current_user).participated_rooms
        render "index"
      end
    end
  end
end
