class SchemesController < ApplicationController

  before_action :authenticate_user!

  def index

  end

  def new
    @scheme = Scheme.new
  end

  def create
    @scheme = Scheme.new scheme_params.merge(user_id: current_user.id)
    binding.pry
    @scheme.save
    redirect_to schemes_path
  end

  def edit

  end

  def update

  end

  private

  def scheme_params
    params.require(:scheme).permit(:name, points: [])
  end
end
