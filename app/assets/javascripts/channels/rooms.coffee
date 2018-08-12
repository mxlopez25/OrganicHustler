
$ ->
  $messages = $('#messages')
  $new_message_form = $('#new-message')
  $new_message_body = $new_message_form.find('#message-body')
  $ticket_id = $new_message_form.find('#message_ticket').val()
  $message_sender = $new_message_form.find('#message_sender').val()
  $notify = $("#notifier")

  if $messages.length > 0
    console.log("Connecting server")
    $notify.css("display", "none")
    App.chat = App.cable.subscriptions.create {
      channel: "ChatChannel",
      room: $new_message_form.find('#message_ticket').val()
    },
      connected: ->

      disconnected: ->

      received: (data) ->
        if data['message']
          $new_message_body.val('')
          $messages.append data['message']
          $messages.append data['ticket']
          $("#mydiv").scrollTop($("#mydiv")[0].scrollHeight)
        if data['writing']
          console.log(data['writing'])
          console.log($message_sender.toString())
          if data['writing'] != $message_sender.toString()
            $notify.finish()
            $notify.css("display", "block")
            $notify.show().delay(1000).fadeOut()

      send_message: (message, ticket, sender) ->
        @perform 'send_message', message: message, ticket: ticket, sender: sender

      send_writing: (sender) ->
        @perform 'send_writing', ticket: $ticket_id, sender: sender

      $new_message_form.submit (e) ->
        $this = $(this)
        message_body = $new_message_body.val()
        message_ticket = $new_message_form.find('#message_ticket').val()
        message_sender = $new_message_form.find('#message_sender').val()
        if $.trim(message_body).length > 0
          App.chat.send_message(message_body, message_ticket, message_sender)

        e.preventDefault()
        return false

      oldVal = ""
      $new_message_body.on "change keyup paste", ->
        currentVal = $(this).val()
        if currentVal == oldVal
          return
        oldVal = currentVal
        App.chat.send_writing($message_sender)