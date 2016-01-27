$(document).on 'click', "[id^=dismiss_btn_]", (event) ->
  button = $(event.target)

  $('#dismiss_until_type').attr('value', button.data('type'))
  $('#dismiss_until_id').attr('value', button.data('id'))

  $('#dismiss_until_modal').openModal()

$(document).ready ->
  $('.modal-footer').on 'click', '#dismiss_until_OK', (e) ->
    # TODO: add validation (date/note)
    e.preventDefault()
    $('#dismiss_until_form').submit()
