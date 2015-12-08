$(document).ready ->
  $('#itinerary_start_date').on 'change', (e) ->
    new_date = $(this).prop('value');

    start_dates = $("[id^=itinerary_itinerary_infos_attributes_][id$=_start_date]")

    start_dates.each (index) ->
      
      $(this).removeClass('invalid')

      current_element_date = $(this).prop('value')

      # start date of first element should be equal to start date
      if (index == 0)
        if current_element_date != new_date
          # console.log 'current_element_date != new_date'
          $(this).addClass('invalid')

      # compare with start date
      if current_element_date < new_date
        # console.log 'current_element_date < new_date'
        $(this).addClass('invalid')

      # compare with previous element
      if (index > 0)
        previous_element = start_dates.eq(index - 1)
        previous_element_date = previous_element.prop('value')
        if current_element_date < previous_element_date
          # console.log 'current_element_date < previous_element_date'
          $(this).addClass('invalid')

      # compare with end_date
      end_date_id = '#itinerary_itinerary_infos_attributes_' + index + '_end_date'
      end_date_element = $(end_date_id)
      end_date_element.removeClass('invalid')
      end_date_date = end_date_element.prop('value')
      if current_element_date > end_date_date
        # console.log 'current_element_date < end_date_date'
        end_date_element.addClass('invalid')
