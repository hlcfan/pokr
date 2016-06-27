desc "Update rooms with slug"
task update_room_slug: :environment do
  Room.find_each do |room|
    permlink = PinYin.permlink(room.name).downcase
    if Room.find_by(slug: permlink).present?
      permlink = "#{permlink}-#{SecureRandom.random_number(100000)}"
    end

    room.slug = permlink
    room.save!
  end
end