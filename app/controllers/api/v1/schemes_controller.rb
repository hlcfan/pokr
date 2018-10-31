module Api
  module V1
    class SchemesController < ActionController::API
      include ActionView::Rendering

      before_action :authenticate_user!

      def index
        @custom_schemes = Scheme.where( user_id: current_user.id ).inject({}) do|hash, scheme|
          hash[scheme.slug] = scheme.name
          hash
        end

        # @custom_schemes.merge!(Scheme.default_schemes)
        default_schemes = Scheme.default_schemes.inject({}) do |hash, (k,v)|
          hash[k] = k.parameterize
          hash
        end

        @custom_schemes.merge! default_schemes
      end
    end
  end
end
