# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

startTime = ->
  today = new Date()
  h = today.getHours()
  m = today.getMinutes()
  m = checkTime(m)
  $("#clock").text(h + ":" + m)
  t = setTimeout(->
    startTime()
    return
  , 500)
  return

checkTime = (i) ->
  i = "0" + i  if i < 10
  i

addIframeStyle = ->
  $("iframe").each ->
    injectCSS = ->
      $head = $iframe.contents().find("head")
      $div = $iframe.contents().find("div.gvC div:first-child")
      $div.remove()
      $head.append $("<link/>",
        rel: "stylesheet"
        href: "stylesheets/calendar.css"
        type: "text/css"
      )
      return
    $iframe = $(this)
    $iframe.on "load", ->
      injectCSS()
      return

    injectCSS()
    return

  return


$(document).ready ->
  startTime()
  addIframeStyle()
  return