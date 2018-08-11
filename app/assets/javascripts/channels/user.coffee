App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    console.log('Listening for new users.')

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    toastMessage(data)