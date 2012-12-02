window.App ||= {}

App.alert = (msg)->
  alert(msg)

jQuery ->

  $('.nav.nav-pills a').each (i,el)->
    if el.href == window.location.href
      $(el).parent().addClass('active')