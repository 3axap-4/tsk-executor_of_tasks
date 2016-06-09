# Place all the behaviors and hooks related to the matching #controller here.
# All this logic will automatically be available in #application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#addNewChoice').on "click", ->
  $('#task_attachments').append($('#new_choice_form').html())

@removeChoice = (element) -> element.parent().remove()