module Api
  module V1
    class SchemesController < ActionController::API
      include ActionView::Rendering

      before_action :authenticate_user!

      def index
        @schemes = Scheme.schemes_of(current_user.id)
      end
    end
  end
end
