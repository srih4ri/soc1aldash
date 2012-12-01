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
