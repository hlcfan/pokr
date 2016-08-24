module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # uniquely identify this connection
    identified_by :current_room_id

    # called when the client first connects
    def connect
      self.current_room_id = find_room_id
    end

    protected

    def find_room_id
      # session isn't accessible here
      if room_id = cookies[:room_id]
        room_id
      else
        # writes a log and raises an exception
        reject_unauthorized_connection
      end
    end
  end
end