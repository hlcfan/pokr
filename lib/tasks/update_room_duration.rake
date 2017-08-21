desc "Update room duration"
task update_room_duration: :environment do
  Room.find_each do |room|
    if room.duration.blank?
      room.duration = room.time_duration  
      room.save!
    end
    puts "Done"
  end
end