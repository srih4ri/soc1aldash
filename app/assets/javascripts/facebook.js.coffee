jQuery ->
  $('.js-like').on('ajax:success', (evt,data,status,xhr)->
     $(this).replaceWith("<span class='liked'>Liked</span>")
  ).on('ajax:error',(err) ->
   App.alert('Could not like ,Please try again later')
  )

  $('.js-fb-reply').on('click', (ev) ->
    $('#js-fb-reply-modal .js-in-reply-to').html("<p>#{$(this).parent().prev().html()}</p>")
    $('#js-fb-reply-modal .js-reply-to-id').val($(this).data('fb-object-id'))
    $('#js-fb-reply-modal').modal()
  )

  $('#js-fb-comment-form').on('ajax:success', (evt,data,status,xhr)->
   if data == null
     App.alert('Could not comment ,Please try again later')
   else
     $('#js-fb-reply-modal').modal('hide')
     App.alert('Commented successfully')
  ).on('ajax:error',(err) ->
   App.alert('Could not comment ,Please try again later')
  )

  $('.js-fb-block').on('click', (ev) ->
    user_id = $(this).data('fb-user-id')
    user_name = $(this).data('fb-user-name')
    $('#js-fb-block-modal .js-confirm b').html(user_name)
    $('#js-fb-block-modal .js-user-name').val(user_id)
    $('#js-fb-block-modal').modal()
  )

  $('#js-fb-block-form').on('ajax:success', (evt,data,status,xhr)->
     $('#js-fb-block-modal').modal('hide')
     App.alert("Blocked user.")
  ).on('ajax:error',(err) ->
   $('#js-fb-block-modal').modal('hide')
   App.alert('Could not block user ,Please try again later')
  )
