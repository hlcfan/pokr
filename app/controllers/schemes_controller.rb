class SchemesController < ApplicationController

  include Premium

  before_action :authenticate_user!
  before_action :set_scheme, except: [:index, :new, :create]
  before_action -> { premium_check("Non-premium user cannot create more than 1 custom schemes.", current_user.schemes.count >= 1) }, only: [:new, :create, :edit]

  def index
    @schemes = Scheme.where user_id: current_user.id
  end

  def new
    @scheme = Scheme.new
  end

  def create
    @scheme = Scheme.new scheme_params.merge(user_id: current_user.id)
    if @scheme.save
      redirect_to schemes_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @scheme.update_attributes scheme_params
      redirect_to schemes_path, flash: { success: "Scheme updated successfully." }
    else
      render :edit
    end
  end

  def destroy
    render :nothing => true, :status => :bad_request and return if @scheme.user_id != current_user.id
    @scheme.destroy
    respond_to do |format|
      format.html { redirect_to schemes_url, notice: "Scheme was successfully destroyed." }
      format.json { head :no_content }
      format.js
    end
  end

  private

  def set_scheme
    @scheme = Scheme.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound if @scheme.nil?
  end

  def scheme_params
    scheme_attributes = params.require(:scheme).permit(:name, points: [])
    scheme_attributes[:points]&.reject!(&:blank?)

    scheme_attributes
  end
end
