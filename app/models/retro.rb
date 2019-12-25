class Retro < ApplicationRecord

  include UidGeneration

  validates_presence_of :name

  def self.new_from_form(params)
    scheme = RetroScheme.find_by(uid: params.delete(:scheme_uid))
    if scheme
      params[:retro_scheme_id] = scheme.id
    else
      params[:retro_scheme_id] = -1
    end

    new(params)
  end
end
