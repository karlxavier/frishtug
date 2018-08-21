App.orders = App.cable.subscriptions.create "OrdersChannel",
  connected: ->
    console.log('Listening for order changes')

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    toastMessage(data)
