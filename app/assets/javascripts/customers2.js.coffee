# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
    $('input[name="user_type"]').on 'click', (event) ->
        curr = event.target.value.toLowerCase()
        $('[id$=_fields]').hide()
        $('#'+curr+'_fields').show()