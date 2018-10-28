module Api
  module V1
    class RoomsController < ActionController::API
      include ActionView::Rendering

      before_action :authenticate_user!

      def index
        @rooms = UserPresenter.new(current_user).participated_rooms
      end
    end
  end
end
