module Api
  module V1
    class SchemesController < ActionController::API
      include ActionView::Rendering

      before_action :authenticate_user!

      def index
        default_schemes = Scheme.default_schemes.inject({}) do |hash, (k,v)|
          hash[v[:name]] = k
          hash
        end

        custom_schemes = Scheme.where( user_id: current_user.id ).inject({}) do|hash, scheme|
          hash[scheme.name] = scheme.slug
          hash
        end

        @schemes = default_schemes.merge custom_schemes
      end
    end
  end
end
