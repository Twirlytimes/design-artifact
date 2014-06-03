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
  
$(document).ready -> startTime()