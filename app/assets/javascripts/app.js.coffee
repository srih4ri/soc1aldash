window.App ||= {}

App.alert = (msg)->
  smoke.signal(msg)

jQuery ->

  $('.nav.nav-pills a').each (i,el)->
    if el.href == window.location.href
      $(el).parent().addClass('active')