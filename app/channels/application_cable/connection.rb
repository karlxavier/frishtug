module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user&.email
    end

    protected

    def find_verified_user
      if cookies.signed['admin.id'].present? 
        Admin.find(cookies.signed['admin.id'])
      elsif cookies.signed['user.id'].present?
        env['warden'].user
      else
        reject_unauthorized_connection
      end
    end
  end
end
