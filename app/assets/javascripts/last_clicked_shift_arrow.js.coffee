class @ItineraryInfosLastCheckedControls
  constructor: ->
    self = this

    $(document).on 'change', '.itinerary-info-checkbox .muli-select-itinerary', (event) ->
      if @checked
        checkbox_array = $('.itinerary-info-checkbox .muli-select-itinerary')
        self.cleanCheckedLast(checkbox_array)
        self.mark_checked_last($(this), checkbox_array)

    $(document).keyup (event) ->
      if event.shiftKey
        starting_index = window.checked_last
        if starting_index != undefined
          checkbox_array = $('.itinerary-info-checkbox .muli-select-itinerary')
          switch event.which
            when 38
              console.log 'sh + up + ' + window.checked_last
              if starting_index != 0
                new_index = starting_index - 1
                window.checked_last = new_index

                checkbox_array[new_index].checked = true                
            when 40
              console.log 'sh + down + ' + window.checked_last
              if starting_index != (checkbox_array.length - 1)
                new_index = starting_index + 1
                window.checked_last = new_index

                checkbox_array[new_index].checked = true
            else
              break
      return

  cleanCheckedLast: (checkbox_array) =>
    delete window.checked_last

  mark_checked_last: (current_checkbox, checkbox_array) =>
    window.checked_last = checkbox_array.index( current_checkbox )

$(document).ready ->
  if window.location.pathname.match(/\/itineraries\/\d+\/edit/)
    new ItineraryInfosLastCheckedControls()

