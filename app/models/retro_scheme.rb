class RetroScheme < ApplicationRecord

  def self.default
    @default ||= DEFAULT_RETRO_SCHEMES
  end

  private

  DEFAULT_RETRO_SCHEMES = [
    RetroScheme.new(
      id: -1,
      uid: "www",
      name: "What Went Well? What Didn't Go Well?",
      user_id: -1,
      col_1: "What Went Well?",
      col_2: "What Didn't Go Well?"
    ),
    RetroScheme.new(
      id: -2,
      uid: "msg",
      name: "The Mad Sad Glad",
      user_id: -1,
      col_1: "Mad",
      col_2: "Sad",
      col_3: "Glad"
    ),
    RetroScheme.new(
      id: -3,
      uid: "4ls",
      name: "4Ls: Liked, Learned, Lacked, & Longed For",
      user_id: -1,
      col_1: "Liked",
      col_2: "Learned",
      col_3: "Lacked",
      col_4: "Longed For"
    ),
    RetroScheme.new(
      id: -4,
      uid: "ssc",
      name: "Start Stop Continue",
      user_id: -1,
      col_1: "Start",
      col_2: "Stop",
      col_3: "Continue"
    )
  ]
end
