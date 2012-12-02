jQuery ->
  $('.js-retweet').on('ajax:success', (evt,data,status,xhr)->
   if data == null
     App.alert('Could not retweet ,Please try again later')
   else
     $('this').replaceWith("<span class='retweeted'>Retweeted</span>")
  ).on('ajax:error',(err) ->
   App.alert('Could not retweet ,Please try again later')
  )

  $('.js-reply').on('click', (ev) ->
    $('#js-reply-modal .js-in-reply-to').html("<p>#{$(this).parent().prev().html()}</p>")
    $('#js-reply-modal .js-reply-to-id').val($(this).data('tweet-id'))
    $('#js-reply-text').val("@#{$(this).data('tweet-screen-name')}")
    $('#js-reply-modal').modal()
  )

  $('#js-reply-modal').on('shown', ->
    # To set focus after screen_name
    txtarea = $('#js-reply-text')
    val = txtarea.val()
    txtarea.focus()
    txtarea.val('')
    txtarea.val(val+' ')
  )

  $('#js-reply-form').on('ajax:success', (evt,data,status,xhr)->
   if data == null
     App.alert('Could not reply ,Please try again later')
   else
     $('#js-reply-modal').modal('hide')
     App.alert('Sent reply')
  ).on('ajax:error',(err) ->
   App.alert('Could not reply ,Please try again later')
  )

  $('.js-twitter-block').on('click', (ev) ->
    screen_name = $(this).data('tweet-screen-name')
    $('#js-twitter-block-modal .js-confirm b').html(screen_name)
    $('#js-twitter-block-modal .js-screen-name').val(screen_name)
    $('#js-twitter-block-modal').modal()
  )

  $('#js-twitter-block-form').on('ajax:success', (evt,data,status,xhr)->
     $('#js-twitter-block-modal').modal('hide')
     App.alert("Blocked user #{data[0].screen_name}")
  ).on('ajax:error',(err) ->
   $('#js-twitter-block-modal').modal('hide')
   App.alert('Could not block user ,Please try again later')
  )