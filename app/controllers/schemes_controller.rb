class SchemesController < ApplicationController

  before_action :authenticate_user!

  def index
    @schemes = Scheme.where user_id: current_user.id
  end

  def new
    @scheme = Scheme.new
  end

  def create
    @scheme = Scheme.new scheme_params.merge(user_id: current_user.id)
    @scheme.save

    redirect_to schemes_path
  end

  def edit

  end

  def update

  end

  private

  def scheme_params
    scheme_attributes = params.require(:scheme).permit(:name, points: [])
    scheme_attributes[:points].reject!(&:blank?)

    scheme_attributes
  end
end
