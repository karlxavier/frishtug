class StocksChannel < ApplicationCable::Channel
  def subscribed
    stream_from "stocks_channel" if current_user.class.name == 'Admin'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
