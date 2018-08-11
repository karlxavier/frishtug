App.stocks = App.cable.subscriptions.create "StocksChannel",
  connected: ->
    console.log('Listening for stock changes')

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    toastMessage(data)
