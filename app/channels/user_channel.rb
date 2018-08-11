class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_channel" if current_user.class.name == 'Admin'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
