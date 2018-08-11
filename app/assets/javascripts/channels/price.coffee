App.price = App.cable.subscriptions.create "PriceChannel",
  connected: ->
    console.log('Listening for price changes.')

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    toastMessage(data)
