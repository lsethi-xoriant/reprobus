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
  $('.modal-footer').on 'click', $('#dismiss_until_OK', '#lost_OK'), (e) ->
    e.preventDefault()
    clicked_selector = $(e.target)
    modal_name = clicked_selector.attr('id').replace("_OK", '')
    note = $('#' + modal_name + '_note')
    date = $('#' + modal_name + '_date')
    $.each [note, date], (index, element) ->
      element.addClass('invalid') if (note.prop('value') == "")
    condition_to_fail_validation = switch
      when modal_name == 'dismiss_until' then (note.hasClass('invalid') && date.hasClass('invalid'))
      when modal_name == 'lost' then (note.hasClass('invalid'))
      else null
    unless condition_to_fail_validation
      $('#' + modal_name + '_form').submit()

# make valid if user start typing
$(document).on 'keyup', $("#dismiss_until_note", '#lost_note'), (e) ->
  selector_to_be_marked_valid = $(e.target)
  selector_to_be_marked_valid.removeClass('invalid')

# make valid if date changes
$(document).on 'change', $('#dismiss_until_date'), (e) ->
  selector_to_be_marked_valid = $(e.target)
  selector_to_be_marked_valid.removeClass('invalid')
