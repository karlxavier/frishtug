class PriceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "price_channel" if current_user.class.name == 'User'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
