module UidGeneration
  extend ActiveSupport::Concern

  included do
    before_create :generate_uid
  end

  def generate_uid
    self.uid = SecureRandom.rand(36**8).to_s(36)
  end
end 