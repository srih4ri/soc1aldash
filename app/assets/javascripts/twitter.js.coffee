jQuery ->
  $('.js-retweet').on('ajax:success', (evt,data,status,xhr)->
   if data == null
     App.alert('Could not retweet ,Please try again later')
   else
     $('this').replaceWith("<span class='retweeted'>Retweeted</span>")
  ).on('ajax:error',(err) ->
   App.alert('Could not retweet ,Please try again later')
  )