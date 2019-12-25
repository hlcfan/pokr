class RetrosController < ApplicationController

  before_action :authenticate_user!, except: [:screen]

  def new
    @retro = Retro.new
    @retro.retro_scheme_id = -1
  end

  def create
    @retro = Retro.new_from_form retro_params.merge(created_by: current_user.id)
    if @retro && @retro.save
      redirect_to retros_path
    else
      render :new
    end
  end

  private

  def retro_params
    retro_attributes = params.require(:retro).permit(:name, :scheme_uid)

    retro_attributes
  end
end

