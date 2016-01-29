class @ItineraryInfosLastCheckedControls
  constructor: ->
    self = this

    $(document).on 'change', '.itinerary-info-checkbox .muli-select-itinerary', (event) ->
      if @checked
        checkbox_array = $('.itinerary-info-checkbox .muli-select-itinerary')
        self.cleanCheckedLast(checkbox_array)
        self.markCheckedLast($(this), checkbox_array)

    $(document).keyup (event) ->
      if event.shiftKey
        starting_index = window.checked_last
        if starting_index != undefined
          checkbox_array = $('.itinerary-info-checkbox .muli-select-itinerary')
          switch event.which
            # shift + up arrow
            when 38
              self.movingUp(starting_index, checkbox_array)
            # shift + down arrow
            when 40
              self.movingDown(starting_index, checkbox_array)
            else
              break
      return

  movingUp: (starting_index, checkbox_array) =>
    if starting_index != 0
      new_index = starting_index - 1
      @changeLastCheckedAndCheckDesired(new_index, checkbox_array)

  movingDown: (starting_index, checkbox_array) =>
    if starting_index != (checkbox_array.length - 1)
      new_index = starting_index + 1
      @changeLastCheckedAndCheckDesired(new_index, checkbox_array)

  changeLastCheckedAndCheckDesired: (new_index, checkbox_array) =>
    window.checked_last = new_index
    checkbox_array[new_index].checked = true

  cleanCheckedLast: (checkbox_array) =>
    delete window.checked_last

  markCheckedLast: (current_checkbox, checkbox_array) =>
    window.checked_last = checkbox_array.index( current_checkbox )

$(document).ready ->
  if window.location.pathname.match(/\/itineraries\/\d+\/edit/)
    new ItineraryInfosLastCheckedControls()

