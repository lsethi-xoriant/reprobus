$(document).on 'click', "[id^=dismiss_btn_]", (event) ->
  # find which 'dismiss until' button clicked
  button = $(event.target)

  # clear validation errors from previous tries on date and note
  $('#dismiss_until_note').removeClass('invalid')
  $('#dismiss_until_date').removeClass('invalid')

  # add hidden fields for form
  $('#dismiss_until_type').attr('value', button.data('type'))
  $('#dismiss_until_id').attr('value', button.data('id'))

  # change submit path
  dismiss_path = '/reminders/' + button.data('id') + '/dismiss'
  $('#dismiss_until_form').attr('action', dismiss_path)

  $('#dismiss_until_modal').openModal()

$(document).on 'click', "[id^=lost_btn_]", (event) ->
  # find which 'lost' button clicked
  button = $(event.target)

  # clear validation errors from previous tries on note
  $('#lost_note').removeClass('invalid')

  # add hidden fields for form
  $('#lost_type').attr('value', button.data('type'))
  $('#lost_id').attr('value', button.data('id'))

  # change submit path
  lost_path = '/reminders/' + button.data('id') + '/lost'
  $('#lost_form').attr('action', lost_path)

  $('#lost_modal').openModal()

$(document).ready ->
  $('.modal-footer').on 'click', '#dismiss_until_OK', (e) ->
    e.preventDefault()

    # invalidate date and note if empty
    note = $('#dismiss_until_note')
    date = $('#dismiss_until_date')
    note.addClass('invalid') if (note.prop('value') == "")
    date.addClass('invalid') if (date.prop('value') == "")

    # submit only if date and note valid
    unless note.hasClass('invalid') || date.hasClass('invalid')
      $('#dismiss_until_form').submit()

$(document).ready ->
  $('.modal-footer').on 'click', '#lost_OK', (e) ->
    e.preventDefault()

    # invalidate note if empty
    note = $('#lost_note')
    note.addClass('invalid') if (note.prop('value') == "")

    # submit only if date and note valid
    unless note.hasClass('invalid')
      $('#lost_form').submit()

$(document).on 'keyup', $('#dismiss_until_note'), (e) ->
  # make valid if user start typing
  $('#dismiss_until_note').removeClass('invalid')

$(document).on 'keyup', $('#lost_note'), (e) ->
  # make valid if user start typing
  $('#lost_note').removeClass('invalid')

$(document).on 'change', $('#dismiss_until_date'), (e) ->
  # make valid if user changed date
  $('#dismiss_until_date').removeClass('invalid')

